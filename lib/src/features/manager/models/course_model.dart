class Course {
  final String id;
  final String name;
  final String description;

  const Course({
    required this.id,
    required this.name,
    required this.description,
  });

  Course copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

class Turma {
  final String id;
  final String cursoId;
  final String nome;
  final int mes;
  final int ano;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final TurmaStatus status;
  final List<String> professorIds;
  final List<String> alunoIds;

  const Turma({
    required this.id,
    required this.cursoId,
    required this.nome,
    required this.mes,
    required this.ano,
    this.dataInicio,
    this.dataFim,
    this.status = TurmaStatus.ativa,
    this.professorIds = const [],
    this.alunoIds = const [],
  });

  Turma copyWith({
    String? id,
    String? cursoId,
    String? nome,
    int? mes,
    int? ano,
    DateTime? dataInicio,
    DateTime? dataFim,
    TurmaStatus? status,
    List<String>? professorIds,
    List<String>? alunoIds,
  }) {
    return Turma(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      nome: nome ?? this.nome,
      mes: mes ?? this.mes,
      ano: ano ?? this.ano,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      status: status ?? this.status,
      professorIds: professorIds ?? this.professorIds,
      alunoIds: alunoIds ?? this.alunoIds,
    );
  }

  String get mesAno {
    final meses = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${meses[mes]}/$ano';
  }
}

enum TurmaStatus { ativa, concluida, cancelada, planejada }

class TurmaMaterial {
  final String id;
  final String turmaId;
  final String titulo;
  final String? descricao;
  final TurmaMaterialType type;
  final String? fileUrl;
  final String? conteudo;
  final DateTime uploadedAt;
  final String? targetAlunoId;

  const TurmaMaterial({
    required this.id,
    required this.turmaId,
    required this.titulo,
    this.descricao,
    this.type = TurmaMaterialType.document,
    this.fileUrl,
    this.conteudo,
    required this.uploadedAt,
    this.targetAlunoId,
  });

  bool get isForAllStudents => targetAlunoId == null;
}

enum TurmaMaterialType { pdf, video, link, document }

class TurmaAula {
  final String id;
  final String turmaId;
  final String titulo;
  final String? descricao;
  final DateTime? data;
  final int order;
  final Duration duration;
  final String? videoUrl;
  final String? conteudo;

  const TurmaAula({
    required this.id,
    required this.turmaId,
    required this.titulo,
    this.descricao,
    this.data,
    this.order = 0,
    this.duration = const Duration(minutes: 30),
    this.videoUrl,
    this.conteudo,
  });

  TurmaAula copyWith({
    String? id,
    String? turmaId,
    String? titulo,
    String? descricao,
    DateTime? data,
    int? order,
    Duration? duration,
    String? videoUrl,
    String? conteudo,
  }) {
    return TurmaAula(
      id: id ?? this.id,
      turmaId: turmaId ?? this.turmaId,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      order: order ?? this.order,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
      conteudo: conteudo ?? this.conteudo,
    );
  }
}

class TurmaDesafio {
  final String id;
  final String turmaId;
  final String titulo;
  final String descricao;
  final String? targetAlunoId;
  final DateTime? prazo;
  final int pontos;
  final List<TurmaDesafioTask> tasks;

  const TurmaDesafio({
    required this.id,
    required this.turmaId,
    required this.titulo,
    required this.descricao,
    this.targetAlunoId,
    this.prazo,
    this.pontos = 100,
    this.tasks = const [],
  });

  bool get isIndividual => targetAlunoId != null;
}

class TurmaDesafioTask {
  final String id;
  final String title;
  final bool isCompleted;

  const TurmaDesafioTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}
