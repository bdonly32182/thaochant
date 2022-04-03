import 'package:chanthaburi_app/models/packagetour/id_name.dart';
import 'package:chanthaburi_app/resources/firestore/location_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SelectLocationTour extends StatefulWidget {
  List<IdAndName> locations;
  SelectLocationTour({Key? key, required this.locations}) : super(key: key);

  @override
  State<SelectLocationTour> createState() => _SelectLocationTourState();
}

class _SelectLocationTourState extends State<SelectLocationTour> {
  final int _pageSize = 10;
  final PagingController<int, QueryDocumentSnapshot<Object?>>
      _pagingController = PagingController(firstPageKey: 0);
  QueryDocumentSnapshot? lastDocument;
  List<IdAndName> selectLocations = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) => loadMoreBuyers(pageKey),
    );
    setState(() {
      selectLocations = widget.locations;
    });
    super.initState();
  }

  Future<void> loadMoreBuyers(int pageKey) async {
    try {
      QuerySnapshot _resultSeller =
          await LocationCollection.allLocations(lastDocument);
      final isLastPage = _resultSeller.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_resultSeller.docs);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(_resultSeller.docs, nextPageKey);
        lastDocument = _resultSeller.docs.last;
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

  onRemoveResort(String id) {
    setState(() {
      selectLocations.removeWhere((element) => element.id == id);
    });
  }

  onAddResort(String id, String name,String imageRef) {
    IdAndName resort = IdAndName(id: id, name: name,imageRef: imageRef);
    setState(() {
      selectLocations.add(resort);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorGuide,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, selectLocations);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => onRefresh()),
        child: PagedListView<int, QueryDocumentSnapshot>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<QueryDocumentSnapshot>(
            itemBuilder: (context, item, index) {
              List<IdAndName> guideSelected = selectLocations
                  .where((guide) => guide.id == item.id)
                  .toList();
              bool isCorrect = guideSelected.isNotEmpty;
              return InkWell(
                onTap: () {
                  if (isCorrect) {
                    onRemoveResort(item.id);
                  } else {
                    onAddResort(item.id, item.get("locationName"),item.get("imageList")[0]);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.get("locationName")),
                      Icon(
                        isCorrect ? Icons.check : null,
                        color: MyConstant.themeApp,
                      ),
                    ],
                  ),
                ),
              );
            },
            firstPageErrorIndicatorBuilder: (_) => const BadRequestError(),
            noItemsFoundIndicatorBuilder: (ctx) => const ShowDataEmpty(),
            firstPageProgressIndicatorBuilder: (context) =>
                const PouringHourGlass(),
            noMoreItemsIndicatorBuilder: (context) => const Center(
              child: Text("ไม่มีข้อมูล"),
            ),
            newPageErrorIndicatorBuilder: (context) => const BadRequestError(),
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
