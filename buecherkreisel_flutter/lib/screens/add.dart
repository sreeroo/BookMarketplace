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
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isImagePickerOpen = false;
    String imageBase64 = widget.listing?.imageBase64 ?? "";

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
          child: Text('Select Image'),
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
          return 'Error: please enter item name';
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
        hintText: "Please enter item description",
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Error: please enter item description';
        }
        return null;
      },
    );

    final priceField = TextFormField(
      key: Key("price"),
      controller: priceController,
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: true),
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Price",
      ),
      validator: (value) {
        if (!RegExp(r'^-?[0-9]+(\.[0-9]+)?$').hasMatch(value!)) {
          return 'Please enter a valid price';
        }
      },
    );
    final locationField = TextFormField(
      key: Key("location"),
      controller: locationController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(hintText: "Location"),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Error: please enter item name';
        }
        return null;
      },
    );

    final saveButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            Listing listing = Listing(
              id: widget.listing?.id ?? 0,
              title: titleController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text),
              location: locationController.text,
              category: "INFORMATIK", // TODO: HARDCODED
              offersDelivery: false, // TODO: HARDCODED
              isReserved: false, // TODO: HARDCODED
              createdBy: int.parse(widget.appState.user.id),
            );

            if (widget.listing == null && _imageFile != null) {
              // Add new listing
              await widget.appState.listingState.api
                  .createListing(listing, _imageFile!)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Listing posted"),
                          duration: Durations.medium3,
                        ),
                      ));
            } else {
              // Update existing listing
              await widget.appState.listingState.api
                  .updateListing(listing, _imageFile)
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Listing updated"),
                          duration: Durations.long2,
                        ),
                      ));
            }

            (widget.listing == null)
                ? {
// Reset the form after posting the advertisement
                    titleController.clear(),
                    descriptionController.clear(),
                    priceController.clear(),
                    locationController.clear(),
                    setState(() {
                      _imageFile = null;
                    })
                  }
                : Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Listing could not be processed"),
                duration: Durations.long2,
              ),
            );
          }
        }
      },
      child: Text(widget.listing == null ? 'Add' : 'Save Changes'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listing == null ? 'Add Listing' : 'Update Listing'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          children: <Widget>[
            imageField,
            nameField,
            descriptionField,
            priceField,
            locationField,
            saveButton
          ],
        ),
      ),
    );
  }
}
