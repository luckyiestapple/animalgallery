import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 249, 140, 86),
        ),
      ),
      home: GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<Map<String, String>> animals = [
    {
      "name": "Kucing",
      "image": "assets/images/cat.jpg",
      "sound": "assets/sounds/cat.mp3",
    },
    {
      "name": "Anjing",
      "image": "assets/images/dog.jpg",
      "sound": "assets/sounds/dog.mp3",
    },
    {
      "name": "Singa",
      "image": "assets/images/lion.jpg",
      "sound": "assets/sounds/lion.mp3",
    },
    {
      "name": "Sapi",
      "image": "assets/images/cow.jpg",
      "sound": "assets/sounds/cow.mp3",
    },
    {
      "name": "Domba",
      "image": "assets/images/sheep.jpg",
      "sound": "assets/sounds/sheep.mp3",
    },
    {
      "name": "Kuda",
      "image": "assets/images/horse.jpg",
      "sound": "assets/sounds/horse.mp3",
    },
    {
      "name": "Gajah",
      "image": "assets/images/elephant.jpg",
      "sound": "assets/sounds/elephant.mp3",
    },
    {
      "name": "Monyet",
      "image": "assets/images/monkey.jpg",
      "sound": "assets/sounds/monkey.mp3",
    },
    {
      "name": "Bebek",
      "image": "assets/images/duck.jpg",
      "sound": "assets/sounds/duck.mp3",
    },
    {
      "name": "Burung",
      "image": "assets/images/bird.jpg",
      "sound": "assets/sounds/bird.mp3",
    },
    {
      "name": "Lumba-lumba",
      "image": "assets/images/Dolphins.jpg",
      "sound": "assets/sounds/Dolphins.mp3",
    },
    {
      "name": "Beruang",
      "image": "assets/images/bear.jpg",
      "sound": "assets/sounds/bear.mp3",
    },
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  int _playCount = 0;
  String? _currentPath;
  int _playRequest = 0;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((event) async {
      if (_currentPath == null) return;

      _playCount++;

      if (_playCount < 3) {
        try {
          await _audioPlayer.play(AssetSource(_currentPath!));
        } catch (e) {
          debugPrint('Gagal memutar suara: $e');
        }
      } else {
        _currentPath = null;
        _playCount = 0;
      }
    });
  }

  Future<void> playSound(String path) async {
    // Membatalkan permintaan pemutaran sebelumnya.
    _playRequest++;
    final int request = _playRequest;

    _currentPath = null;
    _playCount = 0;

    await _audioPlayer.stop();

    // Jika ada permintaan baru saat stop berlangsung,
    // jangan lanjutkan pemutaran permintaan lama.
    if (request != _playRequest) return;

    _currentPath = path.replaceFirst('assets/', '');

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      if (request != _playRequest) return;

      await _audioPlayer.play(AssetSource(_currentPath!));
    } catch (e) {
      _currentPath = null;
      _playCount = 0;
      debugPrint('Gagal memutar suara: $e');
    }
  }

  @override
  void dispose() {
    _currentPath = null;
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dunia Suara Hewan'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: animals.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => playSound(animals[index]['sound']!),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        animals[index]['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      animals[index]['name']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
