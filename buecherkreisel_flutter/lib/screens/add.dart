import 'dart:io';
import 'package:buecherkreisel_flutter/backend/utils.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:provider/provider.dart';

class AddUpdateListing extends StatelessWidget {
  final Listing? listing;
  const AddUpdateListing({Key? key, this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, w) {
        return _AddUpdateListingForm(appState: appState, listing: listing);
      },
    );
  }
}

class _AddUpdateListingForm extends StatefulWidget {
  final AppState appState;
  final Listing? listing;

  const _AddUpdateListingForm({Key? key, required this.appState, this.listing})
      : super(key: key);

  @override
  _AddUpdateListingFormState createState() => _AddUpdateListingFormState();
}

class _AddUpdateListingFormState extends State<_AddUpdateListingForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  late TextEditingController contactController;
  late String? selectedCategory;
  late bool _checkboxValue;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.listing?.title ?? "");
    descriptionController =
        TextEditingController(text: widget.listing?.description ?? "");
    priceController =
        TextEditingController(text: widget.listing?.price.toString() ?? "");
    locationController =
        TextEditingController(text: widget.listing?.location ?? "");
    contactController =
        TextEditingController(text: widget.listing?.contact ?? "");
    selectedCategory = widget.listing == null ? "" : widget.listing!.category;
    _checkboxValue = widget.listing?.offersDelivery ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    locationController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isImagePickerOpen = false;
    String imageBase64 = widget.listing?.imageBase64 ?? "";
    List<String> categories = [];
    widget.appState.listingState.getCategoriesRemote();
    setState(() {
      categories = widget.appState.listingState.categories;
    });

    final imageField = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (imageBase64.isNotEmpty && _imageFile == null)
          Image.memory(
            imageFromBase64String(imageBase64)!.bytes,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        if (_imageFile != null)
          Image.file(
            _imageFile!,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ElevatedButton(
          onPressed: isImagePickerOpen
              ? null
              : () async {
                  setState(() {
                    isImagePickerOpen = true;
                  });
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
          child: Text('Bild auswählen'),
        ),
      ],
    );

    final nameField = TextFormField(
      key: Key("title"),
      controller: titleController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Title"),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Bitte gib einen Titel ein.';
        }
        return null;
      },
    );

    final descriptionField = TextFormField(
      key: Key("desc"),
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Beschreibung",
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Bitte gib eine Beschreibung ein.';
        }
        return null;
      },
    );

    final categoryField = DropdownButtonFormField<String>(
      key: Key("category"),
      value: widget.listing != null ? widget.listing!.category : null,
      decoration: InputDecoration(hintText: "Kategorie"),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value!;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Bitte wähle eine Kategorie aus.';
        }
        return null;
      },
    );

    final priceField = TextFormField(
      key: Key("price"),
      controller: priceController,
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        hintText: "Preis",
      ),
      validator: (value) {
        if (!RegExp(r'^-?[0-9]+(\.[0-9]+)?$').hasMatch(value!)) {
          return 'Bitte gib eine Zahl ein.';
        }
      },
    );
    final locationField = TextFormField(
      key: Key("location"),
      controller: locationController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Ort"),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Bitte gib einen Ort ein.';
        }
        return null;
      },
    );

    final deliveryCheckbox = Row(
      children: <Widget>[
        Checkbox(
          value: _checkboxValue,
          onChanged: (bool? value) {
            setState(() {
              _checkboxValue = value!;
            });
          },
        ),
        Text('Offers Delivery'),
      ],
    );

    final contactField = TextFormField(
      key: Key("contact"),
      controller: contactController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Kontakt (Email, Telefon, ...)"),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Bitte gib Kontaktdaten ein.';
        }
        return null;
      },
    );

    final saveButton = ElevatedButton(
      onPressed: () async {
        if (widget.appState.user.id.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bitte logge dich ein"),
              duration: Durations.long2,
            ),
          );
          return;
        }
        if (_formKey.currentState!.validate()) {
          try {
            Listing listing = Listing(
              id: widget.listing?.id ?? 0,
              title: titleController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text),
              location: locationController.text,
              category: selectedCategory!,
              offersDelivery: _checkboxValue,
              isReserved: false, // TODO: HARDCODED
              contact: contactController.text,
              createdBy: int.parse(widget.appState.user.id),
            );

            if (widget.listing == null) {
              // Add new listing
              await widget.appState.listingState.api
                  .createListing(listing, _imageFile!)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Listing erstellt"),
                          duration: Durations.medium3,
                        ),
                      ));
            } else {
              // Update existing listing
              await widget.appState.listingState.api
                  .patchListing(listing, _imageFile);
              await widget.appState.listingState
                  .getOwnListings(widget.appState.user.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Listing aktualisiert"),
                  duration: Durations.long2,
                ),
              );
            }

            (widget.listing == null)
                ? {
// Reset the form after posting the advertisement
                    titleController.clear(),
                    descriptionController.clear(),
                    priceController.clear(),
                    locationController.clear(),
                    contactController.clear(),
                    setState(() {
                      _imageFile = null;
                    }),
                  }
                : Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Fehler beim Posten des Listings"),
                duration: Durations.long2,
              ),
            );
          }
        }
      },
      child: Text(widget.listing == null ? 'Post' : 'Aktualisieren'),
    );

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.listing == null ? 'Listing erstellen' : 'Bearbeiten'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          children: <Widget>[
            imageField,
            nameField,
            descriptionField,
            categoryField,
            priceField,
            locationField,
            deliveryCheckbox,
            contactField,
            saveButton,
          ],
        ),
      ),
    );
  }
}
