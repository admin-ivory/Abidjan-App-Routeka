// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_import, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:zigzag/config/demo.dart';



class PdfPreviewPage extends StatelessWidget {
  final  data1;
  final  searchbus;
  final  totalPayment;
  const PdfPreviewPage({Key? key, this.data1, this.searchbus, this.totalPayment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(searchbus: searchbus,data1: data1,totalPayment: totalPayment,),
      ),
    );
  }
}