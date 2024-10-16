CREATE TABLE Fornecedores (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Chave primária com auto incremento
    Nome VARCHAR(50) NOT NULL,              -- Nome não permite valores nulos
    CpfCnpj VARCHAR(20) NULL,            -- Descrição permite valores nulos
    Endereco VARCHAR(50) NULL,             -- Categoria permite valores nulos
    Telefone varchar(20) NULL,                 -- Unidade de Medida permite valores nulos
    Email varchar(50) NOT NULL,   -- Preço Unitário não permite valores nulos
	DadosBancarios varchar (50) NOT NULL
);

CREATE TABLE Usuarios (
    ID INT PRIMARY KEY IDENTITY(1,1),       -- Chave primária com auto incremento
    NomeUsuario VARCHAR(50) NOT NULL,       -- Nome de usuário não nulo
    Senha VARCHAR(50) NOT NULL,             -- Senha do usuário não nula
    Email VARCHAR(100) NOT NULL,            -- Email do usuário não nulo
    NivelAcesso INT NOT NULL,               -- Nível de acesso (ex: 1 = Admin, 2 = Usuário)
    DataCriacao DATETIME DEFAULT GETDATE()  -- Data de criação do registro
);


CREATE PROCEDURE ValidarLogin
    @username VARCHAR(50),
    @password VARCHAR(50)
AS
BEGIN
    SELECT * 
    FROM Usuarios
    WHERE NomeUsuario = @username AND Senha = @password;
END


CREATE TABLE Estoque (
    ID INT PRIMARY KEY IDENTITY(1,1),          -- Chave primária com auto incremento
    ProdutoID INT NOT NULL,                    -- ID do produto
    Quantidade INT NOT NULL,                   -- Quantidade do produto em estoque
    DataAtualizacao DATETIME DEFAULT GETDATE(), -- Data de atualização do estoque
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ID) -- Chave estrangeira para a tabela Produtos
);


CREATE PROCEDURE AdicionarAoEstoque
    @produtoID INT,
    @quantidade INT
AS
BEGIN
    INSERT INTO Estoque (ProdutoID, Quantidade, DataAtualizacao)
    VALUES (@produtoID, @quantidade, GETDATE());
END


CREATE PROCEDURE AtualizarEstoque
    @produtoID INT,
    @quantidade INT
AS
BEGIN
    UPDATE Estoque
    SET Quantidade = @quantidade, DataAtualizacao = GETDATE()
    WHERE ProdutoID = @produtoID;
END

CREATE PROCEDURE ConsultarEstoque
    @produtoID INT
AS
BEGIN
    SELECT e.Quantidade, p.Nome
    FROM Estoque e
    INNER JOIN Produtos p ON e.ProdutoID = p.ID
    WHERE e.ProdutoID = @produtoID;
END

CREATE PROCEDURE CadastrarFornecedor
    @Nome VARCHAR(50),
    @CpfCnpj VARCHAR(20) = NULL,
    @Endereco VARCHAR(50) = NULL,
    @Telefone VARCHAR(20) = NULL,
    @Email VARCHAR(50),
    @DadosBancarios VARCHAR(50)
AS
BEGIN
    INSERT INTO Fornecedores (Nome, CpfCnpj, Endereco, Telefone, Email, DadosBancarios)
    VALUES (@Nome, @CpfCnpj, @Endereco, @Telefone, @Email, @DadosBancarios);
END


CREATE PROCEDURE ConsultarFornecedores
AS
BEGIN
    SELECT * FROM Fornecedores;
END



CREATE PROCEDURE AtualizarFornecedor
    @ID INT,
    @Nome VARCHAR(50),
    @CpfCnpj VARCHAR(20) = NULL,
    @Endereco VARCHAR(50) = NULL,
    @Telefone VARCHAR(20) = NULL,
    @Email VARCHAR(50),
    @DadosBancarios VARCHAR(50)
AS
BEGIN
    UPDATE Fornecedores
    SET Nome = @Nome,
        CpfCnpj = @CpfCnpj,
        Endereco = @Endereco,
        Telefone = @Telefone,
        Email = @Email,
        DadosBancarios = @DadosBancarios
    WHERE ID = @ID;
END


CREATE PROCEDURE DeletarFornecedor
    @ID INT
AS
BEGIN
    DELETE FROM Fornecedores WHERE ID = @ID;
END


CREATE PROCEDURE CadastrarProduto
    @nome VARCHAR(50),
    @descricao VARCHAR(500) = NULL,
    @categoria VARCHAR(30) = NULL,
    @unidadeMedida INT = NULL,
    @precoUnitario DECIMAL(18, 0)
AS
BEGIN
    INSERT INTO Produtos (nome, descricao, categoria, unidadeMedida, precoUnitario)
    VALUES (@nome, @descricao, @categoria, @unidadeMedida, @precoUnitario);
    
    -- Verifica se a inserção foi bem-sucedida e retorna um valor
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Produto inserido com sucesso';
    END
    ELSE
    BEGIN
        PRINT 'Falha na inserção do produto';
    END
END


CREATE PROCEDURE AtualizarProduto
    @ID INT,
    @nome VARCHAR(50),
    @descricao VARCHAR(500) = NULL,
    @categoria VARCHAR(30) = NULL,
    @unidadeMedida INT = NULL,
    @precoUnitario DECIMAL(18, 0)
AS
BEGIN
    UPDATE Produtos
    SET nome = @nome,
        descricao = @descricao,
        categoria = @categoria,
        unidadeMedida = @unidadeMedida,
        precoUnitario = @precoUnitario
    WHERE ID = @ID;

    -- Verifica se a atualização foi bem-sucedida
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Produto atualizado com sucesso';
    END
    ELSE
    BEGIN
        PRINT 'Nenhuma alteração foi realizada ou o produto não foi encontrado';
    END
END


CREATE PROCEDURE ExcluirProduto
    @ID INT
AS
BEGIN
    DELETE FROM Produtos
    WHERE ID = @ID;

    -- Verifica se a exclusão foi bem-sucedida
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Produto excluído com sucesso';
    END
    ELSE
    BEGIN
        PRINT 'Produto não encontrado para exclusão';
    END
END


