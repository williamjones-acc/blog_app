import express from "express";
import connection from "../db/index.js";

const router = express.Router();


// GET semua category
router.get("/", async (req, res) => {
    try {
        const [data] = await connection.query(
            "SELECT * FROM categories"
        );

        res.status(200).json({
            message: "Berhasil mengambil data kategori",
            data: data
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal mengambil data kategori"
        });
    }
});


// GET category berdasarkan ID
router.get("/:id", async (req, res) => {
    try {
        const id = req.params.id;

        const [data] = await connection.query(
            "SELECT * FROM categories WHERE id_category = ?",
            [id]
        );

        const categories = data as any[];

        if (categories.length === 0) {
            return res.status(404).json({
                message: "Kategori tidak ditemukan"
            });
        }

        res.status(200).json({
            message: "Berhasil mengambil kategori",
            data: categories[0]
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal mengambil kategori"
        });
    }
});


// POST category
router.post("/", async (req, res) => {
    try {
        const { nama_category } = req.body;

        if (!nama_category) {
            return res.status(400).json({
                message: "Nama kategori wajib diisi"
            });
        }

        const [result] = await connection.query(
            "INSERT INTO categories (nama_category) VALUES (?)",
            [nama_category]
        );

        res.status(201).json({
            message: "Kategori berhasil ditambahkan",
            data: result
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal menambahkan kategori"
        });
    }
});


// PUT category
router.put("/:id", async (req, res) => {
    try {
        const id = req.params.id;
        const { nama_category } = req.body;

        if (!nama_category) {
            return res.status(400).json({
                message: "Nama kategori wajib diisi"
            });
        }

        const [result] = await connection.query(
            "UPDATE categories SET nama_category = ? WHERE id_category = ?",
            [nama_category, id]
        );

        const updateResult = result as any;

        if (updateResult.affectedRows === 0) {
            return res.status(404).json({
                message: "Kategori tidak ditemukan"
            });
        }

        res.status(200).json({
            message: "Kategori berhasil diubah"
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal mengubah kategori"
        });
    }
});


// DELETE category
router.delete("/:id", async (req, res) => {
    try {
        const id = req.params.id;

        const [result] = await connection.query(
            "DELETE FROM categories WHERE id_category = ?",
            [id]
        );

        const deleteResult = result as any;

        if (deleteResult.affectedRows === 0) {
            return res.status(404).json({
                message: "Kategori tidak ditemukan"
            });
        }

        res.status(200).json({
            message: "Kategori berhasil dihapus"
        });
    } catch (error) {
        res.status(500).json({
            message: "Gagal menghapus kategori"
        });
    }
});

export default router;