import 'package:flutter/material.dart';

import '../services/apiservice.dart';
import 'detailpage.dart';
import 'addpage.dart';
import 'edit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();

  List<dynamic> posts = [];
  bool loading = true;

  // 0 = semua
  // 1 = musik
  // 2 = genre musik
  // 3 = alat musik
  // 4 = tips musik
  int selectedCategory = 0;

  final List<String> images = [
    'assets/images/musik1.jpg',
    'assets/images/musik2.jpg',
    'assets/images/musik3.jpg',
    'assets/images/musik4.jpg',
    'assets/images/musik5.jpg',
    'assets/images/musik6.jpg',
    'assets/images/musik7.jpg',
    'assets/images/musik8.jpg',
  ];

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      final data = await apiService.getPosts();

      setState(() {
        posts = data;
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await apiService.deletePost(id);

      await getPosts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Artikel berhasil dihapus"),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  void confirmDelete(int id, String judul) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus artikel"),
          content: Text(
            'Yakin ingin menghapus "$judul"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deletePost(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  Widget categoryButton(String name, int categoryId) {
    final bool active = selectedCategory == categoryId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  String getImage(int index) {
    return images[index % images.length];
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = selectedCategory == 0
        ? posts
        : posts.where(
            (post) => post["id_category"] == selectedCategory,
          ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Artikel Musik",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPage(),
            ),
          );

          if (result == true) {
            getPosts();
          }
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                90,
              ),
              children: [
                // FILTER
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      categoryButton("Semua", 0),
                      const SizedBox(width: 8),
                      categoryButton("Musik", 1),
                      const SizedBox(width: 8),
                      categoryButton("Genre Musik", 2),
                      const SizedBox(width: 8),
                      categoryButton("Alat Musik", 3),
                      const SizedBox(width: 8),
                      categoryButton("Tips Musik", 4),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                if (filteredPosts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 180),
                    child: Center(
                      child: Text(
                        "Belum ada artikel",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                ...List.generate(
                  filteredPosts.length,
                  (index) {
                    final post = filteredPosts[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              post: post,
                              image: getImage(index),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(6),
                              child: Image.asset(
                                getImage(index),
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post["nama_category"] ?? "-",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: Colors.grey,
                                      letterSpacing: 0.4,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    post["judul"] ?? "-",
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  Text(
                                    post["isi"] ?? "-",
                                    maxLines: 3,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      height: 1.35,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      DetailPage(
                                                post: post,
                                                image:
                                                    getImage(
                                                  index,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        style:
                                            TextButton.styleFrom(
                                          padding:
                                              EdgeInsets.zero,
                                          minimumSize:
                                              const Size(50, 30),
                                        ),
                                        child: const Text(
                                          "Baca",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      IconButton(
                                        onPressed: () async {
                                          final result =
                                              await Navigator
                                                  .push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      EditPage(
                                                post: post,
                                              ),
                                            ),
                                          );

                                          if (result == true) {
                                            getPosts();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 19,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints:
                                            const BoxConstraints(),
                                      ),

                                      const SizedBox(width: 12),

                                      IconButton(
                                        onPressed: () {
                                          confirmDelete(
                                            post["id_post"],
                                            post["judul"],
                                          );
                                        },
                                        icon: const Icon(
                                          Icons
                                              .delete_outline,
                                          size: 19,
                                          color: Colors.red,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints:
                                            const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}