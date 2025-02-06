-- Criação do Banco

BEGIN;

-- Tabela: Sigla_UF
CREATE TABLE Sigla_UF (
    Codigo INT,
    Sigla CHAR(2) PRIMARY KEY
);

-- Tabela: Fornecedor
CREATE TABLE Fornecedor (
    CNPJ VARCHAR(14) PRIMARY KEY,
    Nome VARCHAR(100),
    Tel_Fixo VARCHAR(20),
    Tel_Celular VARCHAR(20),
    Cidade VARCHAR(50),
    Bairro VARCHAR(50),
    Numero INT,
    Rua VARCHAR(100),
    CEP VARCHAR(15),
    Sigla_UF CHAR(2),
    FOREIGN KEY (Sigla_UF) REFERENCES Sigla_UF(Sigla)
);

-- Tabela: Cliente
CREATE TABLE Cliente (
    CPF VARCHAR(11) PRIMARY KEY,
    Nome VARCHAR(100),
    Tel_Fixo VARCHAR(20),
    Tel_Celular VARCHAR(20),
    Cidade VARCHAR(50),
    Bairro VARCHAR(50),
    Numero INT,
    CEP VARCHAR(15),
    Sigla_UF CHAR(2),
    FOREIGN KEY (Sigla_UF) REFERENCES Sigla_UF(Sigla)
);

-- Tabela: Produto
CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Estoque INT,
    Valor DECIMAL(10, 2)
);

-- Tabela: Forma_Pagamento
CREATE TABLE Forma_Pagamento (
    Codigo INT,
    Tipo VARCHAR(50) PRIMARY KEY
);

-- Tabela: NF_Compra
CREATE TABLE NF_Compra (
    Codigo INT PRIMARY KEY,
    Data_Emissao DATE,
    Valor DECIMAL(10, 2)
);

-- Tabela: NF_Venda
CREATE TABLE NF_Venda (
    Codigo INT PRIMARY KEY,
    Data_Emissao DATE,
    Valor DECIMAL(10, 2),
    CPF_Cliente VARCHAR(11),
    FOREIGN KEY (CPF_Cliente) REFERENCES Cliente(CPF)
);

-- Tabela: ContaPagar
CREATE TABLE ContaPagar (
    Codigo INT PRIMARY KEY,
    Data_Compra DATE,
    Data_Paga DATE,
    Data_Vencimento DATE,
    Valor DECIMAL(10, 2),
    CNPJ_Fornecedor VARCHAR(14),
    Codigo_NF INT,
    FOREIGN KEY (CNPJ_Fornecedor) REFERENCES Fornecedor(CNPJ),
    FOREIGN KEY (Codigo_NF) REFERENCES NF_Compra(Codigo)
);

-- Tabela: ContaReceber
CREATE TABLE ContaReceber (
    Codigo INT PRIMARY KEY,
    Data_Venda DATE,
    Data_Vencimento DATE,
    Data_Paga DATE,
    Valor DECIMAL(10, 2),
    CPF_Cliente VARCHAR(11),
    FOREIGN KEY (CPF_Cliente) REFERENCES Cliente(CPF)
);

-- Tabela: HistoricoCompra
CREATE TABLE HistoricoCompra (
    Codigo INT PRIMARY KEY,
    Quantidade INT,
    Valor_Uni DECIMAL(10, 2),
    Valor_Total DECIMAL(10, 2),
    Data DATE,
    Codigo_NF INT,
    Codigo_Produto INT,
    CNPJ_Fornecedor VARCHAR(14),
    Tipo_Pagamento VARCHAR(50),
    FOREIGN KEY (Codigo_NF) REFERENCES NF_Compra(Codigo),
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo),
    FOREIGN KEY (CNPJ_Fornecedor) REFERENCES Fornecedor(CNPJ),
    FOREIGN KEY (Tipo_Pagamento) REFERENCES Forma_Pagamento(Tipo)
);

-- Tabela: HistoricoVenda
CREATE TABLE HistoricoVenda (
    Codigo INT PRIMARY KEY,
    Data DATE,
    Codigo_NF INT,
    Codigo_ContaReceber INT,
    Tipo_Pagamento VARCHAR(50),
    FOREIGN KEY (Codigo_NF) REFERENCES NF_Venda(Codigo),
    FOREIGN KEY (Codigo_ContaReceber) REFERENCES ContaReceber(Codigo),
    FOREIGN KEY (Tipo_Pagamento) REFERENCES Forma_Pagamento(Tipo)
);

-- Tabela: Item_NF
CREATE TABLE Item_NF (
    Codigo INT PRIMARY KEY,
    Quantidade INT,
    Valor_Uni DECIMAL(10, 2),
    Valor_Total DECIMAL(10, 2),
    Codigo_NF INT,
    Codigo_Produto INT,
    FOREIGN KEY (Codigo_NF) REFERENCES NF_Venda(Codigo),
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
);

COMMIT;



-- 5 Comandos de Pesquisa

SELECT F.Nome AS Fornecedor, HC.Data, HC.Quantidade, HC.Valor_Total
FROM Fornecedor F
INNER JOIN HistoricoCompra HC ON F.CNPJ = HC.CNPJ_Fornecedor
WHERE F.CNPJ = '12345678000123';


SELECT C.Nome AS Cliente, HV.Data, HV.Tipo_Pagamento, NF.Valor
FROM Cliente C
INNER JOIN NF_Venda NF ON C.CPF = NF.CPF_Cliente
INNER JOIN HistoricoVenda HV ON NF.Codigo = HV.Codigo_NF
WHERE C.CPF = '12345678901';


SELECT P.Nome AS Produto, INF.Quantidade, INF.Valor_Uni, INF.Valor_Total
FROM Item_NF INF
INNER JOIN Produto P ON INF.Codigo_Produto = P.Codigo
WHERE INF.Codigo_NF = 1;


SELECT CP.Codigo, CP.Data_Compra, CP.Data_Vencimento, CP.Valor, F.Nome AS Fornecedor
FROM ContaPagar CP
INNER JOIN Fornecedor F ON CP.CNPJ_Fornecedor = F.CNPJ
WHERE F.CNPJ = '12345678000123';


SELECT CR.Codigo, CR.Data_Venda, CR.Data_Vencimento, CR.Valor, C.Nome AS Cliente
FROM ContaReceber CR
INNER JOIN Cliente C ON CR.CPF_Cliente = C.CPF
WHERE C.CPF = '12345678901';
