import './problem_model.dart';

class ProblemsPageModel{
  int? currentPage;
  int? totalPages;
  List<ProblemModel>? problems;

  ProblemsPageModel({this.currentPage, this.totalPages, this.problems});
}