import express from "express";
import connection from "../db/index.js";

const router = express.Router();


// GET semua artikel
router.get("/", async (req, res) => {
    try {
        const [data] = await connection.query(`
            SELECT
                posts.id_post,
                posts.judul,
                posts.isi,
                posts.id_category,
                categories.nama_category,
                posts.created_at
            FROM posts
            JOIN categories
                ON posts.id_category = categories.id_category
            ORDER BY posts.id_post DESC
        `);

        res.status(200).json({
            message: "Berhasil mengambil data artikel",
            data: data
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal mengambil data artikel"
        });
    }
});


// GET artikel berdasarkan ID
router.get("/:id", async (req, res) => {
    try {
        const id = req.params.id;

        const [data] = await connection.query(`
            SELECT
                posts.id_post,
                posts.judul,
                posts.isi,
                posts.id_category,
                categories.nama_category,
                posts.created_at
            FROM posts
            JOIN categories
                ON posts.id_category = categories.id_category
            WHERE posts.id_post = ?
        `, [id]);

        const posts = data as any[];

        if (posts.length === 0) {
            return res.status(404).json({
                message: "Artikel tidak ditemukan"
            });
        }

        res.status(200).json({
            message: "Berhasil mengambil detail artikel",
            data: posts[0]
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal mengambil detail artikel"
        });
    }
});


// POST artikel
router.post("/", async (req, res) => {
    try {
        const { judul, isi, id_category } = req.body;

        if (!judul || !isi || !id_category) {
            return res.status(400).json({
                message: "Judul, isi, dan kategori wajib diisi"
            });
        }

        const [result] = await connection.query(`
            INSERT INTO posts
            (judul, isi, id_category)
            VALUES (?, ?, ?)
        `, [judul, isi, id_category]);

        res.status(201).json({
            message: "Artikel berhasil ditambahkan",
            data: result
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal menambahkan artikel"
        });
    }
});


// PUT artikel
router.put("/:id", async (req, res) => {
    try {
        const id = req.params.id;
        const { judul, isi, id_category } = req.body;

        if (!judul || !isi || !id_category) {
            return res.status(400).json({
                message: "Judul, isi, dan kategori wajib diisi"
            });
        }

        const [result] = await connection.query(`
            UPDATE posts
            SET judul = ?, isi = ?, id_category = ?
            WHERE id_post = ?
        `, [judul, isi, id_category, id]);

        const updateResult = result as any;

        if (updateResult.affectedRows === 0) {
            return res.status(404).json({
                message: "Artikel tidak ditemukan"
            });
        }

        res.status(200).json({
            message: "Artikel berhasil diubah"
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal mengubah artikel"
        });
    }
});


// DELETE artikel
router.delete("/:id", async (req, res) => {
    try {
        const id = req.params.id;

        const [result] = await connection.query(
            "DELETE FROM posts WHERE id_post = ?",
            [id]
        );

        const deleteResult = result as any;

        if (deleteResult.affectedRows === 0) {
            return res.status(404).json({
                message: "Artikel tidak ditemukan"
            });
        }

        res.status(200).json({
            message: "Artikel berhasil dihapus"
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal menghapus artikel"
        });
    }
});


export default router;