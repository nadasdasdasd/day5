import 'package:day4/blocs/apicubit/api_cubit.dart';
import 'package:day4/helper/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
            create: (_) => ApiCubit(NetworkService()),
            child: DictionaryWidget()));
  }
}

class DictionaryWidget extends StatelessWidget {
  DictionaryWidget({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final apiCubit = context.read<ApiCubit>();
    String word = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit Dio Example'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                onChanged: (value) {
                  word = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a word!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Enter word here ...',
                    contentPadding: EdgeInsets.all(16.0)),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      apiCubit.fetchData('/$word');
                    }
                  },
                  child: const Text('translate to english')),
              BlocBuilder<ApiCubit, ApiState>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ApiSuccess) {
                    return Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text('Data: ${state.response.data}')
                        ],
                      ),
                    ));
                  } else if (state is ApiFailure) {
                    return const Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text('No result.')
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          )),
    );
  }
}
