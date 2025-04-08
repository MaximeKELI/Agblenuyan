import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:agblenuyan/core/constants.dart';
import 'package:agblenuyan/data/models/field.dart';
import 'package:agblenuyan/widgets/field_info_card.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Field> _fields = [];
  LatLng? _currentLocation;
  bool _isLoading = true;
  Field? _selectedField;

  @override
  void initState() {
    super.initState();
    _loadFields();
    _getCurrentLocation();
  }

  Future<void> _loadFields() async {
    // Simulation de chargement des champs
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _fields.addAll([
        Field(
          id: '1',
          name: 'Champ Nord',
          coordinates: LatLng(13.5125, 2.1058),
          area: 2.5,
          cropType: 'Manioc',
          plantedDate: DateTime(2024, 3, 15),
        ),
        Field(
          id: '2',
          name: 'Champ Sud',
          coordinates: LatLng(13.5083, 2.1089),
          area: 1.8,
          cropType: 'Maïs',
          plantedDate: DateTime(2024, 2, 28),
        ),
      ]);
      _isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    // Simulation de localisation
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _currentLocation = LatLng(13.5100, 2.1070);
    });
    _mapController.move(_currentLocation!, 15.0);
  }

  void _addNewField(LatLng position) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddFieldDialog(
              position: position,
              onSave: (newField) {
                setState(() => _fields.add(newField));
                Navigator.pop(context);
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cartographie des Champs"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              if (_currentLocation != null) {
                _mapController.move(_currentLocation!, 15.0);
              }
            },
          ),
          IconButton(icon: Icon(Icons.layers), onPressed: _showMapLayers),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: _currentLocation ?? LatLng(13.5125, 2.1058),
                      zoom: 13.0,
                      onTap: (_, latlng) {
                        setState(() => _selectedField = null);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers:
                            _fields.map((field) {
                              return Marker(
                                point: field.coordinates,
                                width: 40,
                                height: 40,
                                builder:
                                    (ctx) => GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedField = field);
                                      },
                                      child: Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color:
                                            _selectedField == field
                                                ? Colors.red
                                                : AppColors.primary,
                                      ),
                                    ),
                              );
                            }).toList(),
                      ),
                      if (_currentLocation != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentLocation!,
                              width: 30,
                              height: 30,
                              builder:
                                  (ctx) => Icon(
                                    Icons.person_pin_circle,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (_selectedField != null)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: FieldInfoCard(
                        field: _selectedField!,
                        onClose: () => setState(() => _selectedField = null),
                      ),
                    ),
                ],
              ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoomIn',
            mini: true,
            onPressed: () {
              final currentZoom = _mapController.zoom;
              _mapController.move(_mapController.center, currentZoom + 1);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoomOut',
            mini: true,
            onPressed: () {
              final currentZoom = _mapController.zoom;
              _mapController.move(_mapController.center, currentZoom - 1);
            },
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'addField',
            onPressed: () => _addNewField(_mapController.center),
            child: Icon(Icons.add_location),
          ),
        ],
      ),
    );
  }

  void _showMapLayers() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Options de la carte"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text("Carte standard"),
                  onTap: () {
                    // Changer le style de la carte
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.satellite),
                  title: Text("Imagerie satellite"),
                  onTap: () {
                    // Changer le style de la carte
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}

class AddFieldDialog extends StatefulWidget {
  final LatLng position;
  final Function(Field) onSave;

  const AddFieldDialog({required this.position, required this.onSave});

  @override
  _AddFieldDialogState createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<AddFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  String? _selectedCropType;
  final List<String> _cropTypes = ['Manioc', 'Maïs', 'Sorgho', 'Mil', 'Autre'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nouveau Champ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Coordonnées: ${widget.position.latitude.toStringAsFixed(4)}, '
              '${widget.position.longitude.toStringAsFixed(4)}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nom du champ",
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) => value!.isEmpty ? "Ce champ est obligatoire" : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: "Superficie (hectares)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return "Ce champ est obligatoire";
                if (double.tryParse(value) == null) return "Nombre invalide";
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCropType,
              decoration: InputDecoration(
                labelText: "Type de culture",
                border: OutlineInputBorder(),
              ),
              items:
                  _cropTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCropType = newValue;
                });
              },
              validator:
                  (value) => value == null ? "Sélectionnez un type" : null,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newField = Field(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          coordinates: widget.position,
                          area: double.parse(_areaController.text),
                          cropType: _selectedCropType!,
                          plantedDate: DateTime.now(),
                        );
                        widget.onSave(newField);
                      }
                    },
                    child: Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
