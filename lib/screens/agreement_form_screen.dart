import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/header_section.dart';
import '../widgets/section_header.dart';
import '../widgets/icon_field.dart';
import '../widgets/checklist_item.dart';
import '../services/pdf_service.dart';
import 'package:printing/printing.dart';
import '../widgets/autocomplete_field.dart';
import '../data/equipment_data.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl_phone_field/intl_phone_field.dart';

class AgreementFormScreen extends StatefulWidget {
  const AgreementFormScreen({super.key});

  @override
  State<AgreementFormScreen> createState() => _AgreementFormScreenState();
}

class _AgreementFormScreenState extends State<AgreementFormScreen> {
  // ---------- Controllers for Agreement Details ----------
  final customerNameCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final dateCtrl = TextEditingController(
    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );
  final addressCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cslbCtrl = TextEditingController();

  // ---------- Signature Date Controllers (NEW) ----------
  final sigDate1Ctrl = TextEditingController(
    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );
  final sigDate2Ctrl = TextEditingController(
    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );
  final sigDate3Ctrl = TextEditingController(
    text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );

  // ---------- Other State ----------
  String fullPhoneNumber = '';
  final systemSizeInputCtrl = TextEditingController(text: '8.5');
  String systemSizeDisplay = '';

  final ScrollController _scrollController = ScrollController();

  final customerNameKey = GlobalKey();
  final addressKey = GlobalKey();
  final emailKey = GlobalKey();
  final phoneKey = GlobalKey();

  String? customerNameError;
  String? addressError;
  String? emailError;
  String? phoneError;

  String projectType = 'Residential';
  String installationType = 'Roof';

  final Map<String, bool> includedServices = {
    "Design, City Permit, NEM/PTO and (Structural & Electrical Stamp) - Any city or NEM fee not included. Customer will pay.":
        true,
    "Monitoring System": true,
    "All Solar Panel's (25 year manufacturer warranty)": true,
    "The inverter follows the standard manufacturer's warranty": true,
    "The roof has a 12-year warranty under the contractor": true,
  };

  String systemType = 'AP System';
  final rackingCtrl = TextEditingController();
  final panelByCtrl = TextEditingController(
    text: 'Standard Quality Technology Solar Panel',
  );
  final panelModelCtrl = TextEditingController();
  final panelQtyCtrl = TextEditingController(text: '0');
  final inverterByCtrl = TextEditingController();
  final inverterModelCtrl = TextEditingController();
  final inverterQtyCtrl = TextEditingController(text: '0');
  final optimizerByCtrl = TextEditingController();
  final optimizerModelCtrl = TextEditingController();
  final optimizerQtyCtrl = TextEditingController(text: '0');
  final batteryByCtrl = TextEditingController();
  final batteryModelCtrl = TextEditingController();
  final batteryQtyCtrl = TextEditingController(text: '0');

  final Map<String, bool> costChecked = {
    'Solar System': false,
    'Battery': false,
    'Main Panel Upgrade': false,
    'Roofing': false,
    'Other Services': false,
    'Bundle Price': false,
  };
  final Map<String, TextEditingController> costCtrls = {
    'Solar System': TextEditingController(),
    'Battery': TextEditingController(),
    'Main Panel Upgrade': TextEditingController(),
    'Roofing': TextEditingController(),
    'Other Services': TextEditingController(),
    'Bundle Price': TextEditingController(),
  };

  double get totalCost {
    double total = 0;
    costChecked.forEach((key, checked) {
      if (checked) {
        total += double.tryParse(costCtrls[key]!.text) ?? 0;
      }
    });
    return total;
  }

  static const String _emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  void _validateEmailLive(String value) {
    final trimmed = value.trim();
    setState(() {
      if (trimmed.isEmpty) {
        emailError = null;
      } else if (!RegExp(_emailRegex).hasMatch(trimmed)) {
        emailError = 'Invalid email format';
      } else {
        emailError = null;
      }
    });
  }

  bool _validateForm() {
    setState(() {
      customerNameError = customerNameCtrl.text.trim().isEmpty
          ? 'Customer name is required'
          : null;
      addressError = addressCtrl.text.trim().isEmpty
          ? 'Installation address is required'
          : null;

      final emailVal = emailCtrl.text.trim();
      if (emailVal.isEmpty) {
        emailError = 'Email is required';
      } else if (!RegExp(_emailRegex).hasMatch(emailVal)) {
        emailError = 'Invalid email format';
      } else {
        emailError = null;
      }

      phoneError = fullPhoneNumber.trim().isEmpty || fullPhoneNumber.length < 8
          ? 'Valid phone number is required'
          : null;
    });

    GlobalKey? firstErrorKey;
    if (customerNameError != null) {
      firstErrorKey = customerNameKey;
    } else if (addressError != null) {
      firstErrorKey = addressKey;
    } else if (emailError != null) {
      firstErrorKey = emailKey;
    } else if (phoneError != null) {
      firstErrorKey = phoneKey;
    }

    if (firstErrorKey != null) {
      final ctx = firstErrorKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    systemSizeDisplay = '${systemSizeInputCtrl.text} KW';
    for (final c in costCtrls.values) {
      c.addListener(() => setState(() {}));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => dateCtrl.text = DateFormat('MM/dd/yyyy').format(picked));
    }
  }

  // ---------- NEW: Generic Signature Date Picker ----------
  Future<void> _pickSignatureDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => ctrl.text = DateFormat('MM/dd/yyyy').format(picked));
    }
  }

  void _showSystemSizePopup() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          alignment: Alignment.topCenter,
          insetPadding: const EdgeInsets.only(top: 200, left: 40, right: 400),
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: systemSizeInputCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navyBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      systemSizeDisplay = '${systemSizeInputCtrl.text} KW';
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('SET'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======================= BUILD METHOD =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width > 760
                        ? 760
                        : double.infinity,
                  ),
                  child: Stack(
                    children: [
                      // Watermark
                      Positioned.fill(
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.785398,
                            child: const Text(
                              'AD SOLAR INC - SALES & INSTALLATION',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w900,
                                color: Color(0x0A000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // Form
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppTheme.borderGrey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HeaderSection(),
                            SectionHeader('AGREEMENT DETAILS'.toUpperCase()),
                            _agreementDetailsGrid(),
                            SectionHeader('INCLUDED SERVICES'),
                            ..._includedServicesList(),
                            SectionHeader('EQUIPMENT SPECIFICATIONS'),
                            _equipmentSection(),
                            SectionHeader('COST OF JOB'),
                            _costOfJobSection(),
                            const SizedBox(height: 16),
                            _specialInstructionsBox(),
                            const SizedBox(height: 16),
                            _californiaComplianceBox(),
                            const SizedBox(height: 24),
                            _signatureSection(), // <-- UPDATED
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // FAB
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                backgroundColor: const Color(0xFF2D8CFF),
                onPressed: () async {
                  if (!_validateForm()) return;

                  final costsMap = <String, double>{};
                  costChecked.forEach((key, checked) {
                    if (checked) {
                      costsMap[key] =
                          double.tryParse(costCtrls[key]!.text) ?? 0;
                    }
                  });

                  final bytes = await PdfService.generateAgreementPdf(
                    customerName: customerNameCtrl.text,
                    company: companyCtrl.text,
                    date: dateCtrl.text,
                    address: addressCtrl.text,
                    email: emailCtrl.text,
                    phone: fullPhoneNumber,
                    cslb: cslbCtrl.text,
                    projectType: projectType,
                    installationType: installationType,
                    systemSize: systemSizeDisplay,
                    includedServices: includedServices,
                    systemType: systemType,
                    racking: rackingCtrl.text,
                    panelBy: panelByCtrl.text,
                    panelModel: panelModelCtrl.text,
                    panelQty: panelQtyCtrl.text,
                    inverterBy: inverterByCtrl.text,
                    inverterModel: inverterModelCtrl.text,
                    inverterQty: inverterQtyCtrl.text,
                    optimizerBy: optimizerByCtrl.text,
                    optimizerModel: optimizerModelCtrl.text,
                    optimizerQty: optimizerQtyCtrl.text,
                    batteryBy: batteryByCtrl.text,
                    batteryModel: batteryModelCtrl.text,
                    batteryQty: batteryQtyCtrl.text,
                    costs: costsMap,
                    totalCost: totalCost,
                  );

                  final safeName = customerNameCtrl.text.trim().isEmpty
                      ? 'Agreement'
                      : customerNameCtrl.text.trim().replaceAll(
                          RegExp(r'\s+'),
                          '_',
                        );
                  final fileName = 'AD_Solar_$safeName.pdf';

                  final dir = await getApplicationDocumentsDirectory();
                  final file = File('${dir.path}/$fileName');
                  await file.writeAsBytes(bytes);
                  await Printing.sharePdf(bytes: bytes, filename: fileName);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PDF saved: $fileName')),
                    );
                  }
                },
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text(
                  'GENERATE PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= HELPER: PHONE FIELD =======================
  Widget _phoneFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHONE *',
          style: TextStyle(
            color: phoneError != null ? Colors.red : AppTheme.labelGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        IntlPhoneField(
          key: phoneKey,
          controller: phoneCtrl,
          initialCountryCode: 'PK',
          disableLengthCheck: false,
          flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 4),
          dropdownTextStyle: const TextStyle(fontSize: 12),
          style: const TextStyle(fontSize: 12, color: Colors.black),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: phoneError != null ? Colors.red : AppTheme.borderGrey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: phoneError != null ? Colors.red : AppTheme.borderGrey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: phoneError != null ? Colors.red : AppTheme.navyBlue,
                width: 1.5,
              ),
            ),
            errorText: phoneError,
            errorStyle: const TextStyle(fontSize: 11),
          ),
          onChanged: (phone) {
            setState(() => fullPhoneNumber = phone.completeNumber);
          },
        ),
      ],
    );
  }

  // ======================= AGREEMENT DETAILS GRID =======================
  Widget _agreementDetailsGrid() {
    return Column(
      children: [
        // ---- Customer Name / Company / Date ----
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 500;
            final nameField = IconField(
              label: 'Customer Name',
              required: true,
              icon: Icons.person,
              controller: customerNameCtrl,
              fieldKey: customerNameKey,
              errorText: customerNameError,
            );
            final companyField = IconField(
              label: 'Company',
              icon: Icons.apartment,
              controller: companyCtrl,
            );
            final dateField = GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: IconField(
                  label: 'Date',
                  required: true,
                  icon: Icons.calendar_today,
                  controller: dateCtrl,
                  readOnly: true,
                ),
              ),
            );

            if (isNarrow) {
              return Column(
                children: [
                  nameField,
                  const SizedBox(height: 14),
                  companyField,
                  const SizedBox(height: 14),
                  dateField,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: nameField),
                const SizedBox(width: 12),
                Expanded(child: companyField),
                const SizedBox(width: 12),
                Expanded(child: dateField),
              ],
            );
          },
        ),
        const SizedBox(height: 14),

        // ---- Installation Address ----
        IconField(
          label: 'Installation Address',
          required: true,
          icon: Icons.home,
          controller: addressCtrl,
          fieldKey: addressKey,
          errorText: addressError,
        ),
        const SizedBox(height: 14),

        // ---- Email / Phone / CSLB ----
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 500;
            final emailField = IconField(
              label: 'Email',
              required: true,
              icon: Icons.email,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              fieldKey: emailKey,
              errorText: emailError,
              onChanged: _validateEmailLive,
            );
            final phoneField = _phoneFieldWidget();
            final cslbField = IconField(
              label: 'CSLB LIC #',
              icon: Icons.badge,
              controller: cslbCtrl,
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  emailField,
                  const SizedBox(height: 14),
                  phoneField,
                  const SizedBox(height: 14),
                  cslbField,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: emailField),
                const SizedBox(width: 12),
                Expanded(child: phoneField),
                const SizedBox(width: 12),
                Expanded(child: cslbField),
              ],
            );
          },
        ),
        const SizedBox(height: 14),

        // ---- Project Type / Installation / System Size ----
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 500;
            final projectField = _dropdownField('Project Type', projectType, [
              'Residential',
              'Commercial',
            ], (v) => setState(() => projectType = v!));
            final installField = _dropdownField(
              'Installation',
              installationType,
              ['Roof', 'Ground Mount', 'Carport'],
              (v) => setState(() => installationType = v!),
            );
            final sizeField = _systemSizeDropdown();

            if (isNarrow) {
              return Column(
                children: [
                  projectField,
                  const SizedBox(height: 14),
                  installField,
                  const SizedBox(height: 14),
                  sizeField,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: projectField),
                const SizedBox(width: 12),
                Expanded(child: installField),
                const SizedBox(width: 12),
                Expanded(child: sizeField),
              ],
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  //  OTHER METHODS (unchanged except signature)
  // ================================================================

  Widget _systemSizeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SYSTEM SIZE (KW)',
          style: TextStyle(
            color: AppTheme.labelGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        GestureDetector(
          onTap: _showSystemSizePopup,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.borderGrey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  systemSizeDisplay,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                const Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.labelGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderGrey),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _includedServicesList() {
    return includedServices.entries.map((e) {
      return ChecklistItem(
        text: e.key,
        value: e.value,
        onChanged: (val) =>
            setState(() => includedServices[e.key] = val ?? false),
      );
    }).toList();
  }

  Widget _equipmentSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _dropdownField('System Type', systemType, [
                'AP System',
                'Tesla System',
                'Enphase',
                'Solar Age System',
              ], (v) => setState(() => systemType = v!)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AutocompleteField(
                label: 'Racking System',
                controller: rackingCtrl,
                suggestions: EquipmentData.rackingSystems,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _equipmentRow(
          'Panel By:',
          'Panel Model',
          panelByCtrl,
          panelModelCtrl,
          panelQtyCtrl,
          EquipmentData.panelManufacturers,
        ),
        const SizedBox(height: 14),
        _equipmentRow(
          'Inverter By:',
          'Inverter Model',
          inverterByCtrl,
          inverterModelCtrl,
          inverterQtyCtrl,
          EquipmentData.inverterManufacturers,
        ),
        const SizedBox(height: 14),
        _equipmentRow(
          'Optimizer By:',
          'Optimizer Model',
          optimizerByCtrl,
          optimizerModelCtrl,
          optimizerQtyCtrl,
          EquipmentData.optimizerManufacturers,
        ),
        const SizedBox(height: 14),
        _equipmentRow(
          'Battery By:',
          'Battery Model',
          batteryByCtrl,
          batteryModelCtrl,
          batteryQtyCtrl,
          EquipmentData.batteryManufacturers,
        ),
      ],
    );
  }

  Widget _equipmentRow(
    String label1,
    String label2,
    TextEditingController byCtrl,
    TextEditingController modelCtrl,
    TextEditingController qtyCtrl,
    List<String> suggestions,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AutocompleteField(
            label: label1,
            controller: byCtrl,
            suggestions: suggestions,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: AutocompleteField(
            label: label2,
            controller: modelCtrl,
            suggestions: const [],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: IconField(
            label: 'Qty',
            icon: Icons.numbers,
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _costOfJobSection() {
    return Column(
      children: [
        ...costChecked.keys.map((key) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Checkbox(
                  value: costChecked[key],
                  activeColor: AppTheme.navyBlue,
                  onChanged: (v) =>
                      setState(() => costChecked[key] = v ?? false),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    key,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                if (costChecked[key] == true)
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: costCtrls[key],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(prefixText: '\$ '),
                    ),
                  ),
              ],
            ),
          );
        }),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Project Costs:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              '\$${totalCost.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _specialInstructionsBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF0),
        border: Border.all(color: const Color(0xFFFFCC80)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info, size: 14, color: Color(0xFFE65100)),
              SizedBox(width: 6),
              Text(
                'SPECIAL INSTRUCTIONS',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "We do not control any timelines or delays for services such as city approvals, or NEM/PTO. "
            "We submit applications promptly, but approval timing is up to the city or department. "
            "City-required corrections are free; after two customer-requested changes, further changes are "
            "fully charged. Structural or electrical stamping is free if required by the city, but if due to "
            "customer changes, it will be charged. All fees imposed by the department or city are the "
            "customer's responsibility.",
            style: TextStyle(
              fontSize: 9,
              height: 1.4,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              border: Border.all(color: const Color(0xFFFFE0B2)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              "Please note that the material specified in this agreement is subject to change due to "
              "various reasons. We have provided you with the current information, but we reserve the "
              "right to make adjustments as needed.",
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Color(0xFFE65100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================= CALIFORNIA COMPLIANCE (FIXED) =======================
  Widget _californiaComplianceBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FDFF),
        border: Border.all(color: const Color(0xFFD1ECF1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Icon(Icons.balance, size: 14, color: AppTheme.navyBlue),
              SizedBox(width: 6),
              Text(
                'CALIFORNIA LAW COMPLIANCE & PAYMENT TERMS',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: AppTheme.navyBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              border: Border.all(color: const Color(0xFFFFE0B2)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              "Under California law, the initial payment is the lesser of 10% of the contract amount or "
              "\$1,000. Once the documents are ready to be submitted to the city, we will collect 70% of "
              "the contract amount. The balance will be due the day after installation.",
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legalParagraph(
            'Payment Terms:',
            "Upon satisfactory payment being made for any portion of work performed, the contractor shall, prior to any further payment being made, furnish to the person contracting for the home improvement a full and unconditional release from any claim or mechanic's lien pursuant to section 3114 of the civil code for the portion of work which payment has been made. Payment must conform to terms above. Any payment more than 30 days past installation date are subject to 1.5% interest per month. It is the responsibility of the customer to complete whatever documents are necessary to satisfy financing requirement. Failure to do so in a timely manner will cause the entire balance to become due and payable.",
          ),
          const SizedBox(height: 6),
          _legalParagraph(
            'Legal Enforcement:',
            "In the event it should become necessary for the company to institute suit for the enforcement of any of the terms of this contract, purchaser agrees to pay all the company's cost of suit together with reasonable attorney fees. This order is binding on both parties and an authorized representative of the undersigned company. No statement or representation other than as set forth above shall bind any party and any additional work requested by the customer not currently outlined in this agreement will require a signed changes order specifying the work performed and these associated costs.",
          ),
          const SizedBox(height: 6),
          _legalParagraph(
            'Contractor Licensing Requirements:',
            "State law requires anyone who contracts to do construction work to be licensed by the contractor state license board in the license category in which the contractor is going to be working – if the total price of the job is \$500 or more (including labor and materials). CSLB is the state consumer protection agency that licenses and regulates construction contractors. Contact CSLB for information about the licensed contractor you are considering, including information about disclosable complaints, disciplinary actions, and civil judgments that are reported to CSLB.",
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Icon(Icons.shield, size: 12, color: Colors.black),
                        SizedBox(width: 4),
                        Text(
                          'USE ONLY LICENSED',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'CONTRACTORS',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'CSLB License #1027903 • Insured & Bonded',
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 9, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'If you file a complaint: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Within legal deadline (usually four years), CSLB has authority to investigate.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.navyBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'If you use an unlicensed contractor, CSLB may not be able to help you resolve your complaint.',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                SizedBox(height: 4),
                Text(
                  'www.cslb.ca.gov  800.321.CSLB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legalParagraph(String title, String body) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 9,
          height: 1.4,
          color: Color(0xFF444444),
        ),
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }

  // ======================= UPDATED SIGNATURE SECTION =======================
  Widget _signatureSection() {
    return Column(
      children: [
        _signatureRow('Purchaser Signature', sigDate1Ctrl),
        const SizedBox(height: 20),
        _signatureRow('Purchaser Signature', sigDate2Ctrl),
        const SizedBox(height: 20),
        _signatureRow('Contractor Signature (AD SOLAR INC)', sigDate3Ctrl),
      ],
    );
  }

  Widget _signatureRow(String label, TextEditingController dateCtrlForRow) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 38),
              Container(height: 2, color: const Color(0xFF333333)),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: GestureDetector(
            onTap: () => _pickSignatureDate(dateCtrlForRow),
            child: AbsorbPointer(
              child: IconField(
                label: 'Date',
                icon: Icons.calendar_today,
                controller: dateCtrlForRow,
                readOnly: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
