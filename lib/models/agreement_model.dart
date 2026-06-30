class AgreementModel {
  // Customer info
  String customerName = '';
  String company = '';
  DateTime? date;
  String installationAddress = '';
  String email = '';
  String phone = '';
  String cslbLic = '';

  // Project type
  String projectType = 'Residential'; // Residential / Commercial
  String installationType = 'Roof'; // Roof / Ground Mount / Carport
  double systemSizeKw = 0;

  // Equipment
  String systemType =
      'AP System'; // AP System / Tesla System / Enphase / Solar Age System
  String rackingSystem = '';

  String panelBy = '';
  String panelModel = '';
  int panelQty = 0;

  String inverterBy = '';
  String inverterModel = '';
  int inverterQty = 0;

  String optimizerBy = '';
  String optimizerModel = '';
  int optimizerQty = 0;

  String batteryBy = '';
  String batteryModel = '';
  int batteryQty = 0;

  // Cost of job
  double solarSystemCost = 0;
  double batteryCost = 0;
  double mainPanelUpgradeCost = 0;
  double roofingCost = 0;
  double otherServicesCost = 0;
  double bundlePrice = 0;

  double get totalCost =>
      solarSystemCost +
      batteryCost +
      mainPanelUpgradeCost +
      roofingCost +
      otherServicesCost +
      bundlePrice;

  String specialInstructions = '';
}
