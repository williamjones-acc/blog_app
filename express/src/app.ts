import express from "express";
import cors from "cors";

import postRouter from "./routes/post.js";
import categoryRouter from "./routes/category.js";

const app = express();

app.use(cors());
app.use(express.json());


app.get("/", (req, res) => {
    res.status(200).json({
        message: "Backend Aplikasi Blog berhasil berjalan"
    });
});


app.use("/api/posts", postRouter);


app.use("/api/categories", categoryRouter);


app.listen(3000, () => {
    console.log("Server berjalan di http://localhost:3000");
});