import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/fetch/search_result_found.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'component/list_view.dart';

class BuyerList extends StatefulWidget {
  const BuyerList({Key? key}) : super(key: key);

  @override
  _BuyerListState createState() => _BuyerListState();
}

class _BuyerListState extends State<BuyerList> {
  final int _pageSize = 10;
  bool isShowBuyer = false;
  final PagingController<int, QueryDocumentSnapshot<Object?>>
      _pagingController = PagingController(firstPageKey: 0);
  TextEditingController searchController = TextEditingController();
  QueryDocumentSnapshot? lastDocument;
  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) => loadMoreBuyers(pageKey),
    );

    super.initState();
  }

  void onSearch(bool isStatusShow) {
    setState(() {
      isShowBuyer = isStatusShow;
    });
  }

  Future<void> loadMoreBuyers(int pageKey) async {
    try {
      QuerySnapshot _resultBuyer =
          await UserCollection.userRoleList(lastDocument, MyConstant.buyerName);
      final isLastPage = _resultBuyer.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_resultBuyer.docs);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(_resultBuyer.docs, nextPageKey);
        lastDocument = _resultBuyer.docs.last;
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  onRefresh() {
    setState(() {
      lastDocument = null;
    });
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: MyConstant.themeApp,
        title: Form(
          child: Search(
            searchController: searchController,
            onSearch: onSearch,
            labelText: 'ค้นหาสมาชิก :',
            colorIcon: MyConstant.themeApp,
          ),
        ),
      ),
      body: isShowBuyer
          ? FutureBuilder<QuerySnapshot>(
              future: UserCollection.searchUser(
                  searchController.text, MyConstant.buyerName),
              builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const BadRequestError();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List buyers = snapshot.data!.docs;
                  if (buyers.isEmpty) {
                    return const SearchResultFound();
                  }
                  return ListView.builder(
                    itemCount: buyers.length,
                    itemBuilder: (builder, index) => ListViewComponent(
                        role: buyers[index]["role"],
                        fullName: buyers[index]['fullName'],
                        phoneNumber: buyers[index]["phoneNumber"]),
                  );
                }
                return const PouringHourGlass();
              },
            )
          : RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: PagedListView<int, QueryDocumentSnapshot>(
                pagingController: _pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<QueryDocumentSnapshot>(
                  itemBuilder: (context, item, index) {
                    return ListViewComponent(
                      fullName: item.get("fullName"),
                      role: item.get("role"),
                      phoneNumber: item.get("phoneNumber"),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (_) =>
                      const BadRequestError(),
                  noItemsFoundIndicatorBuilder: (ctx) => const ShowDataEmpty(),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const PouringHourGlass(),
                  noMoreItemsIndicatorBuilder: (context) => const Center(
                    child: Text("ไม่มีข้อมูล"),
                  ),
                  newPageErrorIndicatorBuilder: (context) =>
                      const BadRequestError(),
                  newPageProgressIndicatorBuilder: (context) =>
                      CircularProgressIndicator(
                    color: MyConstant.themeApp,
                  ),
                ),
              ),
            ),
    );
  }
}
