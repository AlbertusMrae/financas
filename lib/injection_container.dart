import 'package:supabase_flutter/supabase_flutter.dart';

// Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/buscar_casal_opcional_usecase.dart';
import 'features/auth/domain/usecases/buscar_casal_usecase.dart';
import 'features/auth/domain/usecases/buscar_conjuge_opcional_usecase.dart';
import 'features/auth/domain/usecases/completar_perfil_conjuge_usecase.dart';
import 'features/auth/domain/usecases/registrar_conta_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

// Financas
import 'features/financas/data/datasources/financas_remote_datasource.dart';
import 'features/financas/data/repositories/financas_repository_impl.dart';
import 'features/financas/domain/usecases/buscar_carteiras_usecase.dart';
import 'features/financas/domain/usecases/buscar_lancamentos_usecase.dart';
import 'features/financas/domain/usecases/registrar_lancamento_usecase.dart';
import 'features/financas/presentation/providers/financas_provider.dart';

// Lista de Compras
import 'features/lista_compras/data/datasources/lista_compras_remote_datasource.dart';
import 'features/lista_compras/data/repositories/lista_compras_repository_impl.dart';
import 'features/lista_compras/domain/usecases/buscar_itens_usecase.dart';
import 'features/lista_compras/domain/usecases/adicionar_item_usecase.dart';
import 'features/lista_compras/domain/usecases/marcar_item_usecase.dart';
import 'features/lista_compras/presentation/providers/lista_compras_provider.dart';

// Notas
import 'features/notas/data/datasources/notas_remote_datasource.dart';
import 'features/notas/data/repositories/notas_repository_impl.dart';
import 'features/notas/domain/usecases/buscar_notas_usecase.dart';
import 'features/notas/domain/usecases/salvar_nota_usecase.dart';
import 'features/notas/presentation/providers/notas_provider.dart';

late AuthProvider authProvider;
late FinancasProvider financasProvider;
late ListaComprasProvider listaComprasProvider;
late NotasProvider notasProvider;

void setupDependencies() {
  final client = Supabase.instance.client;

  // Auth
  final authDataSource = AuthRemoteDataSource(client: client);
  final authRepository = AuthRepositoryImpl(dataSource: authDataSource);
  authProvider = AuthProvider(
    signInUseCase: SignInUseCase(repository: authRepository),
    buscarConjugeOpcionalUseCase: BuscarConjugeOpcionalUseCase(
      repository: authRepository,
    ),
    buscarCasalOpcionalUseCase: BuscarCasalOpcionalUseCase(
      repository: authRepository,
    ),
    buscarCasalUseCase: BuscarCasalUseCase(repository: authRepository),
    registrarContaUseCase: RegistrarContaUseCase(repository: authRepository),
    completarPerfilConjugeUseCase: CompletarPerfilConjugeUseCase(
      repository: authRepository,
    ),
    logoutUseCase: LogoutUseCase(repository: authRepository),
  );

  // Financas
  final financasDataSource = FinancasRemoteDataSource(client: client);
  final financasRepository = FinancasRepositoryImpl(
    dataSource: financasDataSource,
  );
  financasProvider = FinancasProvider(
    buscarCarteirasUseCase: BuscarCarteirasUseCase(
      repository: financasRepository,
    ),
    buscarLancamentosUseCase: BuscarLancamentosUseCase(
      repository: financasRepository,
    ),
    registrarLancamentoUseCase: RegistrarLancamentoUseCase(
      repository: financasRepository,
    ),
  );

  // Lista de Compras
  final listaComprasDataSource = ListaComprasRemoteDataSource(client: client);
  final listaComprasRepository = ListaComprasRepositoryImpl(
    dataSource: listaComprasDataSource,
  );
  listaComprasProvider = ListaComprasProvider(
    buscarItensUseCase: BuscarItensUseCase(repository: listaComprasRepository),
    adicionarItemUseCase: AdicionarItemUseCase(
      repository: listaComprasRepository,
    ),
    marcarItemUseCase: MarcarItemUseCase(repository: listaComprasRepository),
  );

  // Notas
  final notasDataSource = NotasRemoteDataSource(client: client);
  final notasRepository = NotasRepositoryImpl(dataSource: notasDataSource);
  notasProvider = NotasProvider(
    buscarNotasUseCase: BuscarNotasUseCase(repository: notasRepository),
    salvarNotaUseCase: SalvarNotaUseCase(repository: notasRepository),
  );
}
