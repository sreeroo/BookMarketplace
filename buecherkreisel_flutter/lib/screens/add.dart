import 'dart:io';
import 'package:buecherkreisel_flutter/backend/ListingAPI.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

// widget class to create stateful new item page
class AddUpdateListing extends StatefulWidget {
  Listing? listing;
  final ListingAPI listingAPI = ListingAPI();

  AddUpdateListing({super.key, this.listing});

  @override
  AddUpdateListingState createState() {
    return AddUpdateListingState();
  }
}

class AddUpdateListingState extends State<AddUpdateListing> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: widget.listing?.title ?? "");
    TextEditingController descriptionController =
        TextEditingController(text: widget.listing?.description ?? "");
    TextEditingController priceController =
        TextEditingController(text: "${widget.listing?.price}" ?? "");
    TextEditingController locationController =
        TextEditingController(text: widget.listing?.location ?? "");

    //titel, beschreibung,preis, beschreibung, bool abholung, location

    final imageField = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _imageFile != null
            ? Image.file(
                _imageFile!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            : ElevatedButton(
                onPressed: () async {
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
        if (!new RegExp(r'^[0-9]+$').hasMatch(value ?? "")) {
          return 'Please enter valid price';
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
      onPressed: () {
        if (_formKey.currentState!.validate() && _imageFile != null) {
          print("ADD!!!");
          Listing listing = Listing(
              id: widget.listing?.id ?? 0,
              title: titleController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text),
              location: locationController.text,
              category: "INFORMATIK", // TODO: HARDCODED
              offersDelivery: false, // TODO: HARDCODED
              isReserved: false, // TODO: HARDCODED
              createdBy: 1);
          widget.listingAPI
              .createListing(listing, _imageFile!)
              .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Advertisement posted successfully"),
                    ),
                  ));

          // Reset the form after posting the advertisement
          titleController.clear();
          descriptionController.clear();
          priceController.clear();
          locationController.clear();
          setState(() {
            _imageFile = null;
          });
        }
      },
      child: Text(widget.listing == null ? 'Add' : 'Save Changes'),
    );

    return Form(
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
    );
  }
}
