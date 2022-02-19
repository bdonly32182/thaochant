import 'package:chanthaburi_app/pages/create_business/create_store.dart';
import 'package:chanthaburi_app/pages/userlist/partner_list.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/search.dart';
import 'package:flutter/material.dart';
import 'approve_partner.dart';

class Partner extends StatefulWidget {
  Partner({Key? key}) : super(key: key);

  @override
  _PartnerState createState() => _PartnerState();
}

class _PartnerState extends State<Partner> {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  void onSearch(bool isStatusShow) {
    setState(() {
      isSearch = isStatusShow;
    });
  }

  void onTap(int tabNumber) {
    setState(() {
      searchController.clear();
      isSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.colorStore,
          title: Form(
            child: Search(
              searchController: searchController,
              onSearch: onSearch,
              labelText: 'ค้นหาพาร์ทเนอร์ :',
              colorIcon: MyConstant.colorStore,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => CreateStore(
                      theme: MyConstant.colorStore,
                      title: 'สร้างธุระกิจให้ผู้ประกอบการ',
                      typeBusiness: value,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'restaurant',
                  child: Text('ร้านอาหาร'),
                ),
                const PopupMenuItem(
                  value: 'otop',
                  child: Text('ร้านผลิตภัณฑ์ชุมชน'),
                ),
                const PopupMenuItem(
                  value: 'resort',
                  child: Text('บ้านพัก'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            onTap: (int tabNumber) => onTap(tabNumber),
            tabs: const [
              Tab(
                icon: Icon(Icons.list_alt_outlined),
                text: "ลิสต์พาร์ทเนอร์",
              ),
              Tab(
                icon: Icon(
                  Icons.approval,
                ),
                text: "อนุมัติพาร์ทเนอร์",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PartnerList(
              textSearch: searchController.text,
              isSearch: isSearch,
            ),
            ApprovePartner(
              textSearch: searchController.text,
              isSearch: isSearch,
            ),
          ],
        ),
      ),
    );
  }
}
