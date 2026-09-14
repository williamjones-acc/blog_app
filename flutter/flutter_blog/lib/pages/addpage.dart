import 'package:flutter/material.dart';
import '../services/apiservice.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ApiService apiService = ApiService();

  final judulController = TextEditingController();
  final isiController = TextEditingController();

  List<dynamic> categories = [];
  int? selectedCategory;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final data = await apiService.getCategories();

      setState(() {
        categories = data;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<void> saveArticle() async {
    if (judulController.text.trim().isEmpty ||
        isiController.text.trim().isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await apiService.addPost(
        judulController.text.trim(),
        isiController.text.trim(),
        selectedCategory!,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tulis Artikel"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Buat artikel baru",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Bagikan tulisanmu tentang musik.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Judul",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                hintText: "Masukkan judul",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Kategori",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              value: selectedCategory,
              decoration: const InputDecoration(
                hintText: "Pilih kategori",
              ),
              items:
                  categories.map<DropdownMenuItem<int>>(
                (category) {
                  return DropdownMenuItem<int>(
                    value: category["id_category"],
                    child: Text(
                      category["nama_category"],
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Isi",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: isiController,
              maxLines: 12,
              decoration: const InputDecoration(
                hintText: "Tulis isi artikel...",
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: loading ? null : saveArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Publikasikan",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}