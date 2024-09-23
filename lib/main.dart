import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookPageTurn(),
    );
  }
}

class BookPageTurn extends StatefulWidget {
  const BookPageTurn({super.key});

  @override
  BookPageTurnState createState() => BookPageTurnState();
}

class BookPageTurnState extends State<BookPageTurn> {
  final GlobalKey<PageFlipWidgetState> _controller =
      GlobalKey<PageFlipWidgetState>();
  late PdfViewerController _pdfViewerController;
  int currentPage = 0; // Начинаем с первой страницы
  final int totalPages = 3; // Укажите общее количество страниц

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Flip Animation - Page $currentPage'),
      ),
      body: PageFlipWidget(
        key: _controller,
        backgroundColor: Colors.white,
        isRightSwipe: true,
        lastPage: Container(
          color: Colors.white,
          child: const Center(child: Text('Last Page!')),
        ),
        children: <Widget>[
          for (var i = 1; i <= totalPages; i++)
            PdfPageView(
              pageNumber: i,
              onPageChanged: _onPageChanged,
              currentPage: currentPage,
              controller: _pdfViewerController,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.navigate_next),
        onPressed: () {
          if (currentPage < totalPages) {
            _controller.currentState?.nextPage();
          }
        },
      ),
    );
  }
}

class PdfPageView extends StatefulWidget {
  final int pageNumber;
  final int currentPage;
  final PdfViewerController controller;
  final ValueChanged<int> onPageChanged;

  const PdfPageView({
    super.key,
    required this.pageNumber,
    required this.currentPage,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  PdfPageViewState createState() => PdfPageViewState();
}

class PdfPageViewState extends State<PdfPageView> {
  @override
  void initState() {
    super.initState();
    // Переход на соответствующую страницу после загрузки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.currentPage != widget.pageNumber) {
        widget.controller.jumpToPage(widget.pageNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.asset(
      'assets/kot_v_sapogah.pdf',
      controller: widget.controller,
      onPageChanged: (details) {
        widget.onPageChanged(details.newPageNumber);
      },
    );
  }
}
