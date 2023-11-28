import 'package:buecherkreisel_flutter/models/insertion.dart';
import 'package:flutter/material.dart';

// widget class to create stateful new item page
class AddUpdateInsertion extends StatefulWidget {
  Insertion? insertion;

  AddUpdateInsertion({super.key, this.insertion});

  @override
  AddUpdateInsertionState createState() {
    return AddUpdateInsertionState();
  }
}

class AddUpdateInsertionState extends State<AddUpdateInsertion> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: widget.insertion?.headline ?? "");
    TextEditingController descriptionController =
        TextEditingController(text: widget.insertion?.description ?? "");
    TextEditingController priceController =
        TextEditingController(text: "${widget.insertion?.price}" ?? "");
    TextEditingController locationController =
        TextEditingController(text: widget.insertion?.location ?? "");

    //titel, beschreibung,preis, beschreibung, bool abholung, location

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
        if (_formKey.currentState!.validate()) {
          print("ADD!!!");
          //_backend
          //    .saveItem(
          //        _client, nameController.text, descriptionController.text,
          //        id: widget.item?.id)
          //    .then((value) => Navigator.pop(context));
        }
      },
      child: Text(widget.insertion == null ? 'Add' : 'Save Changes'),
    );

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: <Widget>[
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
