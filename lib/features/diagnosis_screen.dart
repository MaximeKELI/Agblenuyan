import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  CameraController? _controller;
  bool _isLoading = false;
  bool _isModelLoaded = false;
  String _result = '';
  String _confidence = '';
  XFile? _capturedImage;
  double _analysisProgress = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        ),
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('Erreur caméra: ${e.toString()}');
    }
  }

  Future<void> _loadModel() async {
    try {
      setState(() => _isLoading = true);
      await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/labels.txt',
      );
      setState(() {
        _isModelLoaded = true;
        _isLoading = false;
      });
    } catch (e) {
      _showError('Erreur modèle: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _analyzeImage() async {
    if (_controller == null || !_isModelLoaded) return;

    setState(() {
      _isLoading = true;
      _analysisProgress = 0;
      _result = '';
      _confidence = '';
    });

    try {
      // Capture d'image
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
        _analysisProgress = 0.3;
      });

      // Analyse avec progression simulée
      await Future.delayed(Duration(milliseconds: 300));
      setState(() => _analysisProgress = 0.6);

      final output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.5,
      );

      setState(() => _analysisProgress = 1.0);
      await Future.delayed(Duration(milliseconds: 200));

      if (output != null && output.isNotEmpty) {
        setState(() {
          _result = output[0]['label'] ?? 'Inconnu';
          _confidence =
              '${(output[0]['confidence'] * 100).toStringAsFixed(1)}%';
        });
      } else {
        setState(() => _result = 'Aucun résultat');
      }
    } catch (e) {
      _showError('Erreur analyse: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _resetAnalysis() {
    setState(() {
      _result = '';
      _confidence = '';
      _capturedImage = null;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostic des Plantes'),
        actions: [
          if (_capturedImage != null)
            IconButton(icon: Icon(Icons.refresh), onPressed: _resetAnalysis),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildCameraPreview()),
          _buildAnalysisSection(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_capturedImage != null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 4),
        ),
        child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initialisation de la caméra...'),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: CameraPreview(_controller!),
    );
  }

  Widget _buildAnalysisSection() {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(value: _analysisProgress),
            SizedBox(height: 8),
            Text('Analyse en cours...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (_result.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        children: [
          Text(
            'Résultat du diagnostic:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _result,
            style: TextStyle(fontSize: 24, color: Colors.green[800]),
          ),
          if (_confidence.isNotEmpty)
            Text(
              'Confiance: $_confidence',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showRemediesDialog(context, _result),
            icon: Icon(Icons.medical_services),
            label: Text('Voir les solutions'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: _isLoading ? null : _analyzeImage,
            child: Icon(Icons.camera),
            tooltip: 'Prendre une photo',
          ),
          if (_isModelLoaded && _capturedImage == null)
            FloatingActionButton(
              heroTag: 'btn2',
              onPressed: () => _pickImageFromGallery(),
              child: Icon(Icons.photo_library),
              tooltip: 'Choisir depuis la galerie',
            ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        _capturedImage = image;
        _result = '';
        _confidence = '';
      });
    } catch (e) {
      _showError('Erreur galerie: ${e.toString()}');
    }
  }

  void _showRemediesDialog(BuildContext context, String disease) {
    final remedies = {
      'Mildiou': [
        'Utiliser un fongicide à base de cuivre',
        'Éviter l\'arrosage foliaire',
        'Assurer une bonne circulation d\'air',
      ],
      'Rouille': [
        'Appliquer du soufre micronisé',
        'Enlever les feuilles infectées',
        'Éviter les excès d\'azote',
      ],
      // Ajoutez d'autres maladies et leurs remèdes
    };

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Solutions pour $disease'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                    (remedies[disease] ?? ['Aucune solution connue'])
                        .map(
                          (remedy) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text('• $remedy'),
                          ),
                        )
                        .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fermer'),
              ),
            ],
          ),
    );
  }
}

class ImageSource {
  static var gallery;
}

class ImagePicker {
  pickImage({required source}) {}
}
