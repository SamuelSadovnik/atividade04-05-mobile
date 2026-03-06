

Reflexao do professor, questoes:

O cache foi implementado na camada de dados, dentro do repositório. Isso faz sentido porque o repositório é o responsável por decidir de onde os dados vêm, seja da API remota ou de uma fonte local. Colocar o cache ali mantém essa lógica isolada, sem vazar para outras camadas.

O ViewModel não realiza chamadas HTTP diretamente porque ele não deve saber como os dados são obtidos. Essa é a responsabilidade do repositório. O ViewModel só coordena o estado da tela, e se ele fizesse chamadas HTTP diretamente, ia misturar responsabilidades que não são dele, tornando o código mais difícil de manter e testar.

Se a interface acessasse diretamente o datasource, ela estaria acoplada a um detalhe de implementação que pode mudar a qualquer momento. Além disso, a lógica de cache e tratamento de erros teria que ser duplicada na própria UI, o que vai contra a ideia de separação de responsabilidades.

Essa arquitetura facilita muito a substituição da API por um banco de dados local porque a interface e o ViewModel dependem apenas da abstração do repositório. Para trocar a fonte de dados, bastaria criar uma nova implementação de `ProductRepository` que lê de um banco local, sem precisar alterar nada na interface ou no ViewModel.
