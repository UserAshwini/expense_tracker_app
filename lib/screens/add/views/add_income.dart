import 'package:expense_tracker_app/bloc/create_income/create_income_bloc.dart';
import 'package:expense_tracker_app/bloc/get_incometype/get_incometype_bloc.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/models/incometype.dart';
import 'package:expense_tracker_app/screens/add/widgets/incometype_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController incomeTypeController = TextEditingController();
  TextEditingController incomeDateController = TextEditingController();
  late Income income;
  bool isExpanded = false;
  bool isLoading = false;

  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<GetIncometypeBloc>().add(GetIncometype(uid));
    }
    incomeDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    income = Income.empty;
    income.incomeId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BlocListener<CreateIncomeBloc, CreateIncomeState>(
      listener: (context, state) {
        if (state is CreateIncomeSuccess) {
          Navigator.pop(context, income);
        } else if (state is CreateIncomeLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: BlocBuilder<GetIncometypeBloc, GetIncometypeState>(
                builder: (context, state) {
                  if (state is GetIncometypeSuccess) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                controller: incomeController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      FontAwesomeIcons.indianRupeeSign,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            TextFormField(
                              controller: incomeTypeController,
                              textAlignVertical: TextAlignVertical.center,
                              readOnly: true,
                              onTap: () {},
                              decoration: InputDecoration(
                                  hintText: "Income type",
                                  filled: true,
                                  fillColor:
                                      income.incomeType == IncomeType.empty
                                          ? Colors.white
                                          : Color(income.incomeType.color),
                                  prefixIcon:
                                      income.incomeType == IncomeType.empty
                                          ? const Icon(
                                              FontAwesomeIcons.list,
                                              size: 25,
                                              color: Colors.grey,
                                            )
                                          : Image.asset(
                                              'assets/income/${income.incomeType.icon}.png',
                                              scale: 6,
                                            ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.plus,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      var newIncometype =
                                          await getIncomeTypeCreation(
                                              context, uid);
                                      setState(() {
                                        context
                                            .read<GetIncometypeBloc>()
                                            .add(GetIncometype(uid));
                                        state.incometype
                                            .insert(0, newIncometype);
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      borderSide: BorderSide.none)),
                            ),
                            Visibility(
                              visible:
                                  isExpanded || state.incometype.isNotEmpty,
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                        itemCount: state.incometype.length,
                                        itemBuilder: (context, int i) {
                                          return Card(
                                              child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                income.incomeType =
                                                    state.incometype[i];
                                                incomeTypeController.text =
                                                    income.incomeType.name;
                                              });
                                            },
                                            leading: Image.asset(
                                              'assets/income/${state.incometype[i].icon}.png',
                                              scale: 6,
                                            ),
                                            title:
                                                Text(state.incometype[i].name),
                                            tileColor: Color(
                                                state.incometype[i].color),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ));
                                        })),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: incomeDateController,
                              textAlignVertical: TextAlignVertical.center,
                              readOnly: true,
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: income.date,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)));
                                if (newDate != null) {
                                  setState(() {
                                    incomeDateController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(newDate);
                                    // selectDate = newDate;
                                    income.date = newDate;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Date",
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.clock,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                                width: double.infinity,
                                height: kToolbarHeight,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 35, 34, 34),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12))),
                                        onPressed: () {
                                          setState(() {
                                            income.amount = int.parse(
                                                incomeController.text);
                                          });
                                          context
                                              .read<CreateIncomeBloc>()
                                              .add(CreateIncome(income, uid));
                                        },
                                        child: const Text(
                                          'Save Income',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ))),
    );
  }
}
