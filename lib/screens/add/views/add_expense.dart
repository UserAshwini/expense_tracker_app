import 'package:expense_tracker_app/bloc/create_expense/create_expense_bloc.dart';
import 'package:expense_tracker_app/bloc/create_expense/create_expense_event.dart';
import 'package:expense_tracker_app/bloc/create_expense/create_expense_state.dart';
import 'package:expense_tracker_app/bloc/get_categories/get_category_bloc.dart';
import 'package:expense_tracker_app/bloc/get_categories/get_category_event.dart';
import 'package:expense_tracker_app/bloc/get_categories/get_category_state.dart';
import 'package:expense_tracker_app/models/caregory.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/screens/add/widgets/category_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Expense expense;
  bool isLoading = false;
  bool isExpanded = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, expense);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          // appBar: AppBar(
          //   backgroundColor: Theme.of(context).colorScheme.background,
          // ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
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
                            controller: expenseController,
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
                          controller: categoryController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          onTap: () {},
                          decoration: InputDecoration(
                              hintText: "Category",
                              filled: true,
                              fillColor: expense.category == Category.empty
                                  ? Colors.white
                                  : Color(expense.category.color),
                              prefixIcon: expense.category == Category.empty
                                  ? const Icon(
                                      FontAwesomeIcons.list,
                                      size: 25,
                                      color: Colors.grey,
                                    )
                                  : Image.asset(
                                      'assets/expenses/${expense.category.icon}.png',
                                      scale: 2,
                                    ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  var newCategory =
                                      await getCategoryCreation(context);
                                  setState(() {
                                    context
                                        .read<GetCategoriesBloc>()
                                        .add(GetCategories());
                                    state.categories.insert(0, newCategory);
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
                          visible: isExpanded || state.categories.isNotEmpty,
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
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, int i) {
                                      return Card(
                                          child: ListTile(
                                        onTap: () {
                                          setState(() {
                                            expense.category =
                                                state.categories[i];
                                            categoryController.text =
                                                expense.category.name;
                                          });
                                        },
                                        leading: Image.asset(
                                          'assets/expenses/${state.categories[i].icon}.png',
                                          scale: 2,
                                        ),
                                        title: Text(state.categories[i].name),
                                        tileColor:
                                            Color(state.categories[i].color),
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
                          controller: dateController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: expense.date,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)));
                            if (newDate != null) {
                              setState(() {
                                dateController.text =
                                    DateFormat('dd/MM/yyyy').format(newDate);
                                // selectDate = newDate;
                                expense.date = newDate;
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 35, 34, 34),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    onPressed: () {
                                      setState(() {
                                        expense.amount =
                                            int.parse(expenseController.text);
                                      });
                                      context
                                          .read<CreateExpenseBloc>()
                                          .add(CreateExpense(expense));
                                    },
                                    child: const Text(
                                      'Save Expense',
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
          ),
        ),
      ),
    );
  }
}
