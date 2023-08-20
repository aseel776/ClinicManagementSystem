import 'treatment_model.dart';

class TreatmentsPageModel{
  int? currentPage;
  int? totalPages;
  List<TreatmentModel>? treatments;

  TreatmentsPageModel({this.treatments, this.currentPage, this.totalPages});
}