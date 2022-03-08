import 'package:chanthaburi_app/pages/userlist/component/product_seller_list.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/fetch/search_result_found.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PartnerList extends StatefulWidget {
  final String textSearch;
  final bool isSearch;
  const PartnerList(
      {Key? key, required this.isSearch, required this.textSearch})
      : super(key: key);

  @override
  _PartnerListState createState() => _PartnerListState();
}

class _PartnerListState extends State<PartnerList> {
  TextEditingController searchController = TextEditingController();
  final int _pageSize = 10;
  final PagingController<int, QueryDocumentSnapshot<Object?>>
      _pagingController = PagingController(firstPageKey: 0);
  QueryDocumentSnapshot? lastDocument;

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) => loadMoreBuyers(pageKey),
    );
    super.initState();
  }

  Future<void> loadMoreBuyers(int pageKey) async {
    try {
      QuerySnapshot _resultSeller =
          await UserCollection.sellerList(lastDocument);
      final isLastPage = _resultSeller.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_resultSeller.docs);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(_resultSeller.docs, nextPageKey);
        lastDocument = _resultSeller.docs.last;
      }
    } catch (e) {
      print(e.toString());
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
      body: widget.isSearch && widget.textSearch.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: FutureBuilder<QuerySnapshot>(
                future: UserCollection.searchUser(widget.textSearch),
                builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const BadRequestError();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    List _sellers = snapshot.data!.docs
                        .where((element) =>
                            element["role"] == MyConstant.sellerName)
                        .toList();
                    if (_sellers.isEmpty) {
                      return const SearchResultFound();
                    }
                    return ListView.builder(
                      itemCount: _sellers.length,
                      itemBuilder: (BuildContext ctx, int index) =>
                          ProductSellerList(
                        role: _sellers[index]["role"],
                        fullName: _sellers[index]["fullName"],
                        phoneNumber: _sellers[index]["phoneNumber"],
                        sellerId: _sellers[index].id,
                      ),
                    );
                  }
                  return const PouringHourGlass();
                },
              ),
            )
          : RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: PagedListView<int, QueryDocumentSnapshot>(
                pagingController: _pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<QueryDocumentSnapshot>(
                  itemBuilder: (context, item, index) {
                    return ProductSellerList(
                      role: item.get("role"),
                      fullName: item.get("fullName"),
                      phoneNumber: item.get("phoneNumber"),
                      sellerId: item.id,
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
                    color: MyConstant.colorStore,
                  ),
                ),
              ),
            ),
    );
  }
}
