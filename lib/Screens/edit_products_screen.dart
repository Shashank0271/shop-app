import 'package:flutter/material.dart';
import 'package:my_shop_app/Provider/product.dart';
import 'package:my_shop_app/Provider/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  const EditProductsScreen({Key? key}) : super(key: key);

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _imageUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(title: " ", imageUrl: " ", id: null, description: " ", price: 0);
  var _isinit = true;
  var _isLoading = false;
  var _initValues = {
    'title': ' ',
    'imageUrl': ' ',
    'id': ' ',
    'description': ' ',
    'price': ' ',
  };
  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isinit) {
      var forWardedId = ModalRoute.of(context)!.settings.arguments;
      if (forWardedId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(forWardedId.toString());
        _initValues = {
          'title': _editedProduct.title,
          'id': _editedProduct.id,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isinit = !_isinit;
  }

  @override
  initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    //i.e only update the preview when the url is valid
    if (!_imageUrlFocusNode.hasFocus) {
      String value = _imageUrlController.text;
      if (value.isEmpty) {
        return;
      } else if (!value.startsWith('http') && !value.startsWith('https')) {
        return;
      } else if (!value.endsWith('png') && !value.endsWith('jpg')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    ///triggers all the validators

    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    ///when the last TextFormField is submitted , save the current state of the form
    ///to gain access to the form widget
    ///we need a global key
    _formKey.currentState!.save(); //the new product object is created
    setState(() {
      _isLoading = true;
    });

    ///triggers a method on every textFormField , i.e. the onSaved function
    /// first validate , then save !
    if (_editedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occured'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    } else {
      ///update existing
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(

                    ///stateful widget
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _initValues['title'],
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: value as String,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Provide suitable title';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['price'],
                            decoration:
                                const InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: double.parse(value as String),
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the price !';
                              } else if (double.tryParse(value) == null) {
                                return 'Please enter suitable price';
                              } else if (double.parse(value) <= 0) {
                                return 'Please enter a price greater than 0!';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['description'],
                            decoration:
                                const InputDecoration(labelText: 'Description'),
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            focusNode: _descriptionFocusNode,
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: value as String,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a description!';
                              } else if (value.length < 10) {
                                return 'Description should be at least 10 characters long!';
                              }
                              return null;
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 8, right: 10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                )),
                                child: _imageUrlController.text.isEmpty
                                    ? const Text('Enter a url')
                                    : FittedBox(
                                        child: _formKey.currentState != null &&
                                                _formKey.currentState!
                                                    .validate()
                                            ? Image.network(
                                                _imageUrlController.text)
                                            : Container(),
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    label: Text('Image URL'),
                                  ),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  focusNode: _imageUrlFocusNode,
                                  onEditingComplete: () {
                                    setState(() {});
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onSaved: (value) {
                                    _editedProduct = Product(
                                      title: _editedProduct.title,
                                      price: _editedProduct.price,
                                      description: _editedProduct.description,
                                      imageUrl: value as String,
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite,
                                    );
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an image Url!';
                                    } else if (!value.startsWith('http') &&
                                        !value.startsWith('https')) {
                                      return 'Invalid Url !';
                                    } else if (!value.endsWith('png') &&
                                        !value.endsWith('jpg')) {
                                      return 'Invalid Url !';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ));
  }
}
