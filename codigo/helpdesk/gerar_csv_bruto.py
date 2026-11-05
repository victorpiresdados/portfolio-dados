import random
import csv
from datetime import datetime, timedelta

random.seed(42)

analistas_ids = [1, 2, 3, 4, 5, 6, 7, 8]

categoria_variacoes = {
    "hardware": ["Hardware", "hardware", "HARDWARE", "Hardware ", "hw"],
    "software": ["Software", "software", "SOFTWARE", " Software", "sw"],
    "rede": ["Rede", "rede", "REDE", "Rede ", "rede "],
    "acesso": ["Acesso", "acesso", "ACESSO", " Acesso", "acesso "],
}

prioridade_variacoes = {
    "critica": ["Critica", "critica", "CRITICA", "Crítica", "critica "],
    "alta": ["Alta", "alta", "ALTA", " Alta"],
    "media": ["Media", "media", "MEDIA", "Média", " media"],
    "baixa": ["Baixa", "baixa", "BAIXA", "baixa "],
}

canal_variacoes = {
    "email": ["Email", "email", "E-mail", "EMAIL", "e-mail"],
    "chat": ["Chat", "chat", "CHAT", " Chat"],
    "telefone": ["Telefone", "telefone", "TELEFONE", "Telefone "],
}

tempo_resolucao_horas = {
    "critica": (1, 4),
    "alta": (4, 24),
    "media": (24, 72),
    "baixa": (72, 168),
}

date_formats = ["%Y-%m-%d", "%d/%m/%Y", "%m-%d-%Y", "%d/%m/%y"]

def fmt_data(dt, force_format=None):
    if dt is None:
        return ""
    fmt = force_format if force_format else random.choice(date_formats)
    return dt.strftime(fmt)

rows = []
n_tickets = 260

for i in range(1, n_tickets + 1):
    id_analista = random.choice(analistas_ids)
    cat_key = random.choice(list(categoria_variacoes.keys()))
    prio_key = random.choice(list(prioridade_variacoes.keys()))
    canal_key = random.choice(list(canal_variacoes.keys()))

    categoria = random.choice(categoria_variacoes[cat_key])
    prioridade = random.choice(prioridade_variacoes[prio_key])
    canal = random.choice(canal_variacoes[canal_key])

    data_abertura = datetime.now() - timedelta(days=random.randint(0, 180), hours=random.randint(0, 23))

    ainda_aberto = random.random() < 0.15
    if ainda_aberto:
        data_fechamento = None
        status = random.choice(["Aberto", "aberto", "ABERTO", "Em andamento", "em andamento"])
    else:
        min_h, max_h = tempo_resolucao_horas[prio_key]
        horas = random.randint(min_h, max_h)
        data_fechamento = data_abertura + timedelta(hours=horas)
        status = random.choice(["Resolvido", "resolvido", "RESOLVIDO", "Fechado", "fechado"])

    # alguns registros com id_analista em branco (falha de preenchimento)
    id_analista_out = "" if random.random() < 0.03 else id_analista

    row = {
        "id_ticket": i,
        "id_analista": id_analista_out,
        "categoria": categoria,
        "prioridade": prioridade,
        "canal": canal,
        "data_abertura": fmt_data(data_abertura),
        "data_fechamento": fmt_data(data_fechamento) if data_fechamento else "",
        "status": status,
    }
    rows.append(row)

# duplicar umas 15 linhas de propósito (dado duplicado é um problema clássico de limpeza)
for _ in range(15):
    rows.append(dict(random.choice(rows)))

random.shuffle(rows)

fieldnames = ["id_ticket", "id_analista", "categoria", "prioridade", "canal", "data_abertura", "data_fechamento", "status"]

out_path = "tickets_bruto.csv"
with open(out_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print(f"Gerado {len(rows)} linhas em {out_path}")
