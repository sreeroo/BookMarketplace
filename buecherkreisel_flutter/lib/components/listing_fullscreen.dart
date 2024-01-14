import 'package:buecherkreisel_flutter/backend/UserAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/backend/utils.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingFullScreen extends StatefulWidget {
  final Listing listing;
  final User user;

  const ListingFullScreen({Key? key, required this.listing, required this.user}) : super(key: key);

  @override
  _ListingFullScreenState createState() => _ListingFullScreenState();
}

class _ListingFullScreenState extends State<ListingFullScreen> with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> isLiked; 
  late AnimationController _animationController;
  MemoryImage? _listingImage;

  @override
  void initState() {
    super.initState();
    isLiked = ValueNotifier(widget.user.likedListings.contains(widget.listing.id));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animationController.forward();
    if (widget.listing.imageBase64 != null) {
      _listingImage = MemoryImage(imageFromBase64String(widget.listing.imageBase64!)!.bytes); // Create the MemoryImage here
    }
  }

  @override
  void dispose() {
    isLiked.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AppState>(builder: (c, appState, w) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.listing.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: widget.listing.isReserved ? 0.25 : 1,
                    child: _listingImage != null 
                    ? Image(image: _listingImage!, fit: BoxFit.cover) // Use the cached image
                      : Image.memory(
                            imageFromBase64String("")!.bytes,
                            fit: BoxFit.cover,
                        ),
                  ),
                  if (widget.listing.isReserved)
                    Container(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent mask
                      child: const Center(
                        child: Text(
                          'Reserviert', 
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.listing.title,
                    overflow: TextOverflow.clip,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isLiked,
                    builder: (context, isLikedValue, child) {
                      return GestureDetector(
                        onTap: () {
                          if(widget.user.id == ""){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Bitte logge dich ein"),
                                duration: Durations.long2,
                              ),
                            );
                          } else {
                            isLiked.value = !isLiked.value;
                            if (isLiked.value) {
                              widget.user.likedListings.add(widget.listing.id);
                              appState.setUser(widget.user); 
                            } else {
                              widget.user.likedListings.remove(widget.listing.id);
                              appState.setUser(widget.user);
                            }
                            UserAPI().updateLikedListings(widget.user); 
                            
                            _animationController
                              .reverse()
                              .then((value) => _animationController.forward());
                          }
                        },
                        child: ScaleTransition(
                          scale: Tween(begin: 0.7, end: 1.0).animate(
                            CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
                          ),
                          child: Icon(
                            isLikedValue ? Icons.favorite : Icons.favorite_border,
                            color: isLikedValue ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.listing.price}€',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ort: ${widget.listing.location}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Kategorie: ${widget.listing.category}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                'Beschreibung:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.listing.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                'Kontakt:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.listing.contact,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Versand möglich: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(
                    widget.listing.offersDelivery
                        ? Icons.check_circle_sharp
                        : Icons.cancel_sharp,
                    color: widget.listing.offersDelivery ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
