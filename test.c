#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <tree_sitter/api.h>

TSLanguage *tree_sitter_commonlisp();

int main()
{
    // Create a parser.
    TSParser *parser = ts_parser_new();

    ts_parser_set_language(parser, tree_sitter_commonlisp());

    // Build a syntax tree based on source code stored in a string.
    const char *source_code = "(+ 1 2)";
    TSTree *tree = ts_parser_parse_string(
        parser,
        NULL,
        source_code,
        strlen(source_code));

    // Get the root node of the syntax tree.
    TSNode root_node = ts_tree_root_node(tree);

    // Print the syntax tree as an S-expression.
    char *string = ts_node_string(root_node);
    printf("Syntax tree: %s\n", string);

    // Free all of the heap-allocated memory.
    free(string);
    ts_tree_delete(tree);
    ts_parser_delete(parser);
    return 0;
}
