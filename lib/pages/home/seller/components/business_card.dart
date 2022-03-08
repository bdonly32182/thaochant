import 'package:chanthaburi_app/pages/business/home/home_business.dart';
import 'package:chanthaburi_app/pages/business/menu/otop/menu_otops.dart';
import 'package:chanthaburi_app/pages/business/menu/resort/rooms.dart';
import 'package:chanthaburi_app/pages/business/menu/restaurant/menu_restaurant.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String sellerId;
  final String businessName;
  final String businessId;
  bool isAdmin;
  String typeBusiness;
  BusinessCard(
      {Key? key,
      required this.businessName,
      required this.sellerId,
      required this.businessId,
      required this.typeBusiness,
      required this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (typeBusiness == MyConstant.foodCollection) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => isAdmin
                  ? Menu(businessId: businessId)
                  : HomeBusiness(
                      businessId: businessId,
                      businessWidget: Menu(businessId: businessId),
                      typeBusiness: typeBusiness,
                    ),
            ),
          );
        }
        if (typeBusiness == MyConstant.productOtopCollection) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => isAdmin
                  ? MenuOtops(businessId: businessId)
                  : HomeBusiness(
                      businessId: businessId,
                      businessWidget: MenuOtops(businessId: businessId),
                      typeBusiness: typeBusiness,
                    ),
            ),
          );
        }
        if (typeBusiness == MyConstant.roomCollection) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => isAdmin
                  ? Rooms(businessId: businessId)
                  : HomeBusiness(
                      businessId: businessId,
                      businessWidget: Rooms(businessId: businessId),
                      typeBusiness: typeBusiness,
                    ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(14.0),
        width: width * 0.5,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  businessName,
                  style: TextStyle(
                    color: MyConstant.colorStore,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: MyConstant.colorStore,
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 0.4),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
