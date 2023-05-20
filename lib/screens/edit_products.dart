import 'package:flutter/material.dart';

import '../providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/decoration_widget.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = "/edit-products";

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _discreptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0.0);
  var initStart = true;
  var isLoading = false;
  var _initalProduct = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageNode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initStart) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;

        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initalProduct = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    initStart = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageFocusNode.removeListener(_updateImageNode);
    _priceFocusNode.dispose();
    _discreptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
  }

  void _updateImageNode() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        setState(() {});
      } else if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else if (_editedProduct.id.isEmpty) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Error occurd"),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("ok"))
                  ],
                ));
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var appBarTheme = AppBarTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
        title: const Text("edit products"),
        elevation: appBarTheme.elevation,
        backgroundColor: appBarTheme.backgroundColor,
        centerTitle: appBarTheme.centerTitle,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
          const Color(0xFF495579),
          const Color(0xFF3C2A21),
        ))),
      ),
      body: isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: CustomLinearGradient.baseBackgroundDecoration(
                  const Color(0xFF495579),
                  const Color(0xFF3C2A21),
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            )
          : Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFF495579),
                Color(0xFF3C2A21),
              ])),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _initalProduct['title'],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              gapPadding: 10),
                          label: const Text(
                            "title",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value.toString(),
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initalProduct['price'],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text(
                            "Price",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_discreptionFocusNode),
                        onSaved: (value) {
                          _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value!));
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "please enter a vaild price";
                          }
                          if (double.parse(value) <= 0) {
                            return "please enter a price greater than 0 ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: _initalProduct['description'],
                        style: const TextStyle(color: Colors.white),
                        focusNode: _discreptionFocusNode,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text(
                            "Discreption",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        maxLines: 3,
                        maxLength: 200,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value.toString(),
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a text";
                          }
                          if (value.length < 10) {
                            return "please enter a text greater than 10 letters ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(top: 5, right: 5),
                              child: _imageUrlController.text.isEmpty
                                  ? const Text("enter image url")
                                  : FittedBox(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  label: const Text("Image Url",
                                      style: TextStyle(color: Colors.white))),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    isFavorite: _editedProduct.isFavorite,
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: value.toString(),
                                    price: _editedProduct.price);
                              },
                              focusNode: _imageFocusNode,
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return "please enter an image url";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "please enter a vaild image url";
                                }
                                if (!value.endsWith(".jpg") &&
                                    !value.endsWith(".png") &&
                                    !value.endsWith(".jpeg")) {
                                  return "please enter a vaild url";
                                }
                                return null;
                              }),
                            ),
                          ),
                        ],
                      )
                    ]),
                  )),
            ),
    );
  }
}
