import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static const navy = PdfColor.fromInt(0xFF002D62);
  static const green = PdfColor.fromInt(0xFF43A047);
  static const amberBg = PdfColor.fromInt(0xFFFFF3CD);
  static const amberBorder = PdfColor.fromInt(0xFFFFEEBA);
  static const orangeBoxBg = PdfColor.fromInt(0xFFFFFAF0);
  static const orangeBoxBorder = PdfColor.fromInt(0xFFFFCC80);
  static const orangeStripBg = PdfColor.fromInt(0xFFFFF3E0);
  static const orangeStripBorder = PdfColor.fromInt(0xFFFFE0B2);
  static const orangeText = PdfColor.fromInt(0xFFE65100);
  static const blueBoxBg = PdfColor.fromInt(0xFFF8FDFF);
  static const blueBoxBorder = PdfColor.fromInt(0xFFD1ECF1);
  static const redText = PdfColor.fromInt(0xFFD32F2F);
  static const greyText = PdfColor.fromInt(0xFF444444);

  static Future<Uint8List> generateAgreementPdf({
    required String customerName,
    required String company,
    required String date,
    required String address,
    required String email,
    required String phone,
    required String cslb,
    required String projectType,
    required String installationType,
    required String systemSize,
    required Map<String, bool> includedServices,
    required String systemType,
    required String racking,
    required String panelBy,
    required String panelModel,
    required String panelQty,
    required String inverterBy,
    required String inverterModel,
    required String inverterQty,
    required String optimizerBy,
    required String optimizerModel,
    required String optimizerQty,
    required String batteryBy,
    required String batteryModel,
    required String batteryQty,
    required Map<String, double> costs,
    required double totalCost,
  }) async {
    final pdf = pw.Document();

    // ---------------- PAGE 1 ----------------
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => pw.Stack(
          children: [
            pw.Positioned.fill(child: _watermark()),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _header(),
                _sectionTitle('AGREEMENT DETAILS'),
                _rowField('Customer Name', customerName, 'Company', company),
                _rowField('Date', date, 'Installation Address', address),
                _rowField('Email', email, 'Phone', phone),
                _rowField('CSLB LIC #', cslb, 'Project Type', projectType),
                _rowField(
                  'Installation',
                  installationType,
                  'System Size',
                  systemSize,
                ),
                _sectionTitle('INCLUDED SERVICES'),
                ...includedServices.entries
                    .where((e) => e.value)
                    .map(
                      (e) => pw.Bullet(
                        text: e.key,
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ),
                _sectionTitle('EQUIPMENT SPECIFICATIONS'),
                _rowField('System Type', systemType, 'Racking System', racking),
                _rowField('Panel By', panelBy, 'Panel Model', panelModel),
                _rowField('Panel Qty', panelQty, 'Inverter By', inverterBy),
                _rowField(
                  'Inverter Model',
                  inverterModel,
                  'Inverter Qty',
                  inverterQty,
                ),
                _rowField(
                  'Optimizer By',
                  optimizerBy,
                  'Optimizer Model',
                  optimizerModel,
                ),
                _rowField(
                  'Optimizer Qty',
                  optimizerQty,
                  'Battery By',
                  batteryBy,
                ),
                _rowField(
                  'Battery Model',
                  batteryModel,
                  'Battery Qty',
                  batteryQty,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // ---------------- PAGE 2 ----------------
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => pw.Stack(
          children: [
            pw.Positioned.fill(child: _watermark()),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle('COST OF JOB'),
                ...costs.entries.map(
                  (e) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          e.key,
                          style: const pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '\$${e.value.toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Divider(thickness: 1),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Project Costs:',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    pw.Text(
                      '\$${totalCost.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                        color: PdfColors.green800,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 14),
                _specialInstructionsBox(),
                pw.SizedBox(height: 14),
                _californiaComplianceBox(date),
                pw.SizedBox(height: 24),
                _signatureLine('Purchaser Signature', date),
                pw.SizedBox(height: 20),
                _signatureLine('Purchaser Signature', date),
                pw.SizedBox(height: 20),
                _signatureLine('Contractor Signature (AD SOLAR INC)', date),
              ],
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  static pw.Widget _watermark() {
    return pw.Center(
      child: pw.Transform.rotate(
        angle: -0.4,
        child: pw.Opacity(
          opacity: 0.04,
          child: pw.Text(
            'AD SOLAR INC - SALES & INSTALLATION',
            style: pw.TextStyle(fontSize: 36, fontWeight: pw.FontWeight.bold),
          ),
        ),
      ),
    );
  }

  static pw.Widget _header() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'AD SOLAR INC',
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: navy,
          ),
        ),
        pw.Text(
          'American Direct Solar',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          decoration: pw.BoxDecoration(
            color: green,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Center(
            child: pw.Text(
              '619-436-1997   |   info@adsolar.us   |   www.adsolar.us',
              style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'SALES & INSTALLATION AGREEMENT',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: pw.BoxDecoration(
            color: amberBg,
            border: pw.Border.all(color: amberBorder),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                const pw.TextSpan(
                  text: 'State Contractor License ',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.TextSpan(
                  text: '#1027903',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: redText,
                  ),
                ),
                const pw.TextSpan(
                  text: ' Insured and Bonded',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(top: 8, bottom: 6),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: navy,
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _rowField(
    String label1,
    String val1,
    String label2,
    String val2,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              '$label1: $val1',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              '$label2: $val2',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _specialInstructionsBox() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: orangeBoxBg,
        border: pw.Border.all(color: orangeBoxBorder),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SPECIAL INSTRUCTIONS',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: orangeText,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            "We do not control any timelines or delays for services such as city approvals, or NEM/PTO. "
            "We submit applications promptly, but approval timing is up to the city or department. "
            "City-required corrections are free; after two customer-requested changes, further changes are "
            "fully charged. Structural or electrical stamping is free if required by the city, but if due to "
            "customer changes, it will be charged. All fees imposed by the department or city are the "
            "customer's responsibility.",
            style: pw.TextStyle(fontSize: 8, color: greyText),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: pw.BoxDecoration(
              color: orangeStripBg,
              border: pw.Border.all(color: orangeStripBorder),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              "Please note that the material specified in this agreement is subject to change due to "
              "various reasons. We have provided you with the current information, but we reserve the "
              "right to make adjustments as needed.",
              style: pw.TextStyle(
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
                color: orangeText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _californiaComplianceBox(String date) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: blueBoxBg,
        border: pw.Border.all(color: blueBoxBorder),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CALIFORNIA LAW COMPLIANCE & PAYMENT TERMS',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: navy,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: pw.BoxDecoration(
              color: orangeStripBg,
              border: pw.Border.all(color: orangeStripBorder),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              "Under California law, the initial payment is the lesser of 10% of the contract amount or "
              "\$1,000. Once the documents are ready to be submitted to the city, we will collect 70% of "
              "the contract amount. The balance will be due the day after installation.",
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),
          _legal(
            'Payment Terms:',
            "Upon satisfactory payment being made for any portion of work performed, the contractor shall, prior to any further payment being made, furnish to the person contracting for the home improvement a full and unconditional release from any claim or mechanic's lien pursuant to section 3114 of the civil code for the portion of work which payment has been made. Payment must conform to terms above. Any payment more than 30 days past installation date are subject to 1.5% interest per month. It is the responsibility of the customer to complete whatever documents are necessary to satisfy financing requirement. Failure to do so in a timely manner will cause the entire balance to become due and payable.",
          ),
          pw.SizedBox(height: 5),
          _legal(
            'Legal Enforcement:',
            "In the event it should become necessary for the company to institute suit for the enforcement of any of the terms of this contract, purchaser agrees to pay all the company's cost of suit together with reasonable attorney fees. This order is binding on both parties and an authorized representative of the undersigned company. No statement or representation other than as set forth above shall bind any party and any additional work requested by the customer not currently outlined in this agreement will require a signed changes order specifying the work performed and these associated costs.",
          ),
          pw.SizedBox(height: 5),
          _legal(
            'Contractor Licensing Requirements:',
            "State law requires anyone who contracts to do construction work to be licensed by the contractor state license board in the license category in which the contractor is going to be working – if the total price of the job is \$500 or more (including labor and materials). CSLB is the state consumer protection agency that licenses and regulates construction contractors. Contact CSLB for information about the licensed contractor you are considering, including information about disclosable complaints, disciplinary actions, and civil judgments that are reported to CSLB.",
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'USE ONLY LICENSED CONTRACTORS',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'CSLB License #1027903 • Insured & Bonded',
                    style: const pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
              pw.SizedBox(
                width: 220,
                child: pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 8),
                    children: [
                      const pw.TextSpan(
                        text: 'If you file a complaint: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      const pw.TextSpan(
                        text:
                            'Within legal deadline (usually four years), CSLB has authority to investigate.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: navy,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(
                  width: 280,
                  child: pw.Text(
                    'If you use an unlicensed contractor, CSLB may not be able to help you resolve your complaint.',
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
                pw.Text(
                  'www.cslb.ca.gov  800.321.CSLB',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _legal(String title, String body) {
    return pw.RichText(
      text: pw.TextSpan(
        style: pw.TextStyle(fontSize: 8, color: greyText),
        children: [
          pw.TextSpan(
            text: '$title ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: body),
        ],
      ),
    );
  }

  // ============================================================
  // REPLACED _signatureLine WITH NEW IMPLEMENTATION
  // ============================================================
  static pw.Widget _signatureLine(String label, String date) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 25),
              pw.Container(
                height: 2,
                color: PdfColor.fromInt(0xFF333333), // 2px solid #333
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        pw.SizedBox(
          width: 100,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Date', style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFFEEEEEE), // #eee
                  ),
                  color: PdfColor.fromInt(0xFFFAFAFA), // #fafafa
                ),
                child: pw.Text(date, style: const pw.TextStyle(fontSize: 9)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
