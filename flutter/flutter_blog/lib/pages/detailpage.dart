import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final dynamic post;
  final String image;

  const DetailPage({
    super.key,
    required this.post,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Artikel",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: 230,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    post["nama_category"] ?? "-",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    post["judul"] ?? "-",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Artikel #${post["id_post"]}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 25),

                  Text(
                    post["isi"] ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.75,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Dibuat pada",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "${post["created_at"]}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}