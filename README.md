# m2t
Matlab matrix to LaTeX converter

m2t(matrix) gives LaTeX representation of matrix. Default setting is
    matrix with square bracktes. 
 
    Supported commands:
 
        m2t(matrix, 'environment', {'matrix'|'tabular'}, 
         'border', {'yes'|'no'}, 'align', {'r'|'c'|'l'}, 
         'brackets', {'[' or '(' or '{' or '|' or '||'},
         'decimantion', number)
 
        if 'filename' option is specified, tex source code will be saved in
        given filename
 
    Example:
 
    m2t(matrix, 'filename', 'mymatrix.tex')
 
    m2t(matrix, 'brackets', '(', 'decimation', 5)
 
      \begin{pmatrix}
       1.00000 & 2.00000 \\ 
       3.00000 & 4.00000 \\ 
      \end{pmatrix}
 
 
    for bug report contact martin@klauco.com
