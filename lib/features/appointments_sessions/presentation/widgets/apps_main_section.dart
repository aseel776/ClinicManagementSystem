import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './appointments_table.dart';
import './upsert_appointment.dart';
import '../states/control_states.dart';
import '../states/appointments/appointments_provider.dart';
import './/core/app_colors.dart';

class AppointmentsMainSection extends StatelessWidget {

  const AppointmentsMainSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width * .83;
    final screenHeight = MediaQuery.of(context).size.height * .93;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: AppColors.lightGrey,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * .1,
              child: const Text(
                'قسم المواعيد',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * .4,
              height: screenHeight * .05,
              child: Consumer(
                builder: (_, ref, __) {
                  final displayedDate = ref.watch(selectedDate);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight * .05,
                        width: screenWidth * .1,
                        child: Tooltip(
                          message: 'السابق',
                          textStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                          ),
                          child: FloatingActionButton(
                            heroTag: Object(),
                            onPressed: () async{
                              ref.read(selectedDate.notifier).state = displayedDate.subtract(const Duration(days: 1));
                              ref.read(appointmentsProvider.notifier).getAllAppointments(ref.read(selectedDate).toString());
                            },
                            backgroundColor: AppColors.black,
                            child: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * .005),
                      SizedBox(
                        width: screenWidth * .125,
                        height: screenHeight * .05,
                        child: InkWell(
                          onTap: () async {
                            await selectDate(context, ref);
                          },
                          child: Text(
                            displayedDate.toString(),
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 22,
                                color: AppColors.black
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * .005),
                      SizedBox(
                        height: screenHeight * .05,
                        width: screenWidth * .1,
                        child: Tooltip(
                          message: 'التالي',
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                          ),
                          child: FloatingActionButton(
                            heroTag: Object(),
                            onPressed: () async{
                              ref.read(selectedDate.notifier).state = displayedDate.add(const Duration(days: 1));
                              ref.read(appointmentsProvider.notifier).getAllAppointments(ref.read(selectedDate).toString());
                            },
                            backgroundColor: AppColors.black,
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: screenHeight * .85,
              child: Row(
                children: [
                  AppointmentsTable(
                  tableHeight: screenHeight * .85,
                  tableWidth: screenWidth * .85,
                  ),
                  SizedBox(
                    width: screenWidth * .025 / 2,
                  ),
                  SizedBox(
                    width: screenWidth * .125,
                    child: Consumer(
                      builder: (context, ref, child) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * .125,
                                child: MaterialButton(
                                  onPressed: () async {
                                    await showUpsertAppointment(
                                      context: context,
                                      ref: ref,
                                      type: 'normal',
                                    );
                                  },
                                  color: AppColors.black,
                                  minWidth: screenWidth * .125,
                                  height: screenHeight * .075,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'إضافة موعد',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Cairo'
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * .025),
                              SizedBox(
                                width: screenWidth * .125,
                                child: MaterialButton(
                                  onPressed: () async{
                                    await showUpsertAppointment(
                                      context: context,
                                      ref: ref,
                                      type: 'waiting',
                                    );
                                  },
                                  color: AppColors.black,
                                  minWidth: screenWidth * .125,
                                  height: screenHeight * .075,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'إدخال من الانتظار',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                    ),
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * .025),
                              SizedBox(
                                width: screenWidth * .125,
                                child: MaterialButton(
                                  onPressed: () async{
                                    await showUpsertAppointment(
                                      context: context,
                                      ref: ref,
                                      type: 'emergency',
                                    );
                                  },
                                  color: AppColors.black,
                                  minWidth: screenWidth * .125,
                                  height: screenHeight * .075,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'إدخال إسعافي',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Cairo',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * .025),
                              SizedBox(
                                width: screenWidth * .125,
                                child: MaterialButton(
                                  onPressed: () {
                                    print('external');
                                  },
                                  color: AppColors.black,
                                  minWidth: screenWidth * .125,
                                  height: screenHeight * .075,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'المواعيد الخارجية',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Cairo'
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    )
                  ),
                  SizedBox(
                    width: screenWidth * .025 / 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> selectDate(BuildContext context, WidgetRef ref) async{
    final date = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    final oldDate = ref.read(selectedDate);
    if(date != null && date != oldDate){
      ref.read(selectedDate.notifier).state = date;
      ref.read(appointmentsProvider.notifier).getAllAppointments(date.toString());
    }
  }
}
