import 'package:flutter/material.dart';
import 'package:agblenuyan/data/models/crop.dart';
import 'package:agblenuyan/widgets/crop_card.dart';

class CropsScreen extends StatefulWidget {
  @override
  _CropsScreenState createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  final List<Crop> _crops = [];
  final _searchController = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _filter = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Crop> get _filteredCrops {
    return _crops.where((crop) {
      return crop.name.toLowerCase().contains(_filter.toLowerCase());
    }).toList();
  }

  void _addCrop(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddCropDialog(
              onSave: (newCrop) => setState(() => _crops.add(newCrop)),
            ),
          ),
    );
  }

  void _editCrop(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddCropDialog(
              crop: _crops[index],
              onSave: (updatedCrop) {
                setState(() {
                  _crops[index] = updatedCrop;
                });
              },
            ),
          ),
    );
  }

  void _deleteCrop(int index) {
    setState(() {
      _crops.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Cultures"),
        actions: [
          IconButton(icon: Icon(Icons.sort), onPressed: _showSortOptions),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                _filteredCrops.isEmpty
                    ? Center(
                      child: Text(
                        _filter.isEmpty
                            ? 'Aucune culture enregistrée'
                            : 'Aucun résultat',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredCrops.length,
                      itemBuilder:
                          (context, index) => Dismissible(
                            key: Key(_filteredCrops[index].name),
                            background: Container(color: Colors.red),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Confirmer'),
                                      content: Text(
                                        'Supprimer ${_filteredCrops[index].name} ?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: Text(
                                            'Supprimer',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            onDismissed: (direction) => _deleteCrop(index),
                            child: InkWell(
                              onTap: () => _editCrop(context, index),
                              child: CropCard(crop: _filteredCrops[index]),
                            ),
                          ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCrop(context),
        icon: Icon(Icons.add),
        label: Text('Nouvelle Culture'),
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Trier par'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Nom (A-Z)'),
                  onTap: () {
                    setState(() {
                      _crops.sort((a, b) => a.name.compareTo(b.name));
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Date (récent)'),
                  onTap: () {
                    setState(() {
                      _crops.sort(
                        (a, b) => b.plantedDate.compareTo(a.plantedDate),
                      );
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Superficie (grande)'),
                  onTap: () {
                    setState(() {
                      _crops.sort((a, b) => b.area.compareTo(a.area));
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}

class AddCropDialog extends StatefulWidget {
  final Function(Crop) onSave;
  final Crop? crop;

  AddCropDialog({required this.onSave, this.crop});

  @override
  _AddCropDialogState createState() => _AddCropDialogState();
}

class _AddCropDialogState extends State<AddCropDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _areaController;
  late TextEditingController _dateController;
  DateTime _plantedDate = DateTime.now();
  String? _selectedCropType;
  final List<String> _cropTypes = [
    'Céréale',
    'Légume',
    'Fruit',
    'Tubercule',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.crop?.name ?? '');
    _areaController = TextEditingController(
      text: widget.crop?.area.toString() ?? '',
    );
    _dateController = TextEditingController(
      text: _formatDate(widget.crop?.plantedDate ?? DateTime.now()),
    );
    _plantedDate = widget.crop?.plantedDate ?? DateTime.now();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _plantedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _plantedDate) {
      setState(() {
        _plantedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

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
              widget.crop == null
                  ? 'Ajouter une culture'
                  : 'Modifier la culture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nom de la culture",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.eco),
              ),
              validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: "Superficie (hectares)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.square_foot),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return "Champ obligatoire";
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
                prefixIcon: Icon(Icons.category),
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
            SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Date de plantation",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
              readOnly: true,
              validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newCrop = Crop(
                          name: _nameController.text,
                          plantedDate: _plantedDate,
                          area: double.parse(_areaController.text),
                          type: _selectedCropType,
                        );
                        widget.onSave(newCrop);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
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
