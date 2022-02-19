import 'package:chanthaburi_app/pages/services/seller_service.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class ProductSellerList extends StatefulWidget {
  final String sellerId;
  final String fullName;
  final String role;
  final String phoneNumber;
  const ProductSellerList({
    Key? key,
    required this.role,
    required this.fullName,
    required this.phoneNumber,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<ProductSellerList> createState() => _ProductSellerListState();
}

class _ProductSellerListState extends State<ProductSellerList> {
  Map<String, dynamic> _amountProductSeller = {
    "restaurant": 0,
    "resort": 0,
    "otop": 0,
  };
  @override
  void initState() {
    super.initState();
    getAmountProductSeller();
  }

  void getAmountProductSeller() async {
    Map<String, dynamic>? amountProductSeller =
        await UserCollection.amountProductSeller(widget.sellerId);
    setState(() {
      _amountProductSeller = amountProductSeller;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        width: width * 1,
        height: 130,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SellerService(
                  sellerId: widget.sellerId,
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: width * 0.2,
                    height: 70,
                    child: Icon(
                      Icons.person_outline,
                      color: MyConstant.colorStore,
                      size: 50,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: MyConstant.colorStore, width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: width * 0.7,
                      margin: EdgeInsets.only(left: width * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.library_books,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    widget.fullName,
                                    style: TextStyle(
                                      color: MyConstant.colorStore,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                widget.phoneNumber,
                                style: TextStyle(
                                  color: MyConstant.colorStore,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                widget.role,
                                style: TextStyle(
                                  color: MyConstant.colorStore,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.home,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                _amountProductSeller["resort"].toString(),
                                style: TextStyle(
                                    color: MyConstant.colorStore,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Icons.restaurant_menu_sharp,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                _amountProductSeller["restaurant"].toString(),
                                style: TextStyle(
                                    color: MyConstant.colorStore,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Icons.store_rounded,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                _amountProductSeller["otop"].toString(),
                                style: TextStyle(
                                    color: MyConstant.colorStore,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
