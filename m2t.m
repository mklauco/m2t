function m2t(matrix, varargin)
%% Matlab matrix to LaTeX converter
%
%   m2t(matrix) gives LaTeX representation of matrix. Default setting is
%   matrix with square brackets. 
%
%   Supported commands:
%
%       m2t(matrix, 'environment', {'matrix'|'tabular'}, 
%        'border', {'yes'|'no'}, 'align', {'r'|'c'|'l'}, 
%        'brackets', {'[' or '(' or '{' or '|' or '||'},
%        'decimantion', number)
%
%       if 'filename' option is specified, tex source code will be saved in
%       given filename
%
%   Example:
%
%   matrix = [1, 2; 3, 4];
%   m2t(matrix, 'filename', 'mymatrix.tex');
%
%   m2t(matrix, 'brackets', '(', 'decimation', 5);
%
%     \begin{pmatrix}
%      1.00000 & 2.00000 \\ 
%      3.00000 & 4.00000 \\ 
%     \end{pmatrix}
%
%
%   for bug report contact martin@klauco.com
%   version 1.0

%% input check
if (numel(matrix) < 1)
    error('Matrix M must have at least one element')
end

%% input parser
p = inputParser;
defaultEnvironment  = 'matrix';
expectedEnvironment = {'matrix', 'tabular'};

defaultAlign  = 'cc';
expectedAlign = {'c', 'r', 'l'};

defaultBorder  = 'no';
expectedBorder = {'no', 'yes'};

defaultBrackets  = 'br';
expectedBrackets = {'[', ']', '(', ')', '{', '}', '|', '||'};

defaultDecimation = 2;

defaultFilename = '-';

p.addParamValue('environment', defaultEnvironment, ...
                @(q) any(validatestring(q, expectedEnvironment)));
            
p.addParamValue('align', defaultAlign, ...
                @(q) any(validatestring(q, expectedAlign)));
            
p.addParamValue('border', defaultBorder, ...
                @(q) any(validatestring(q, expectedBorder)));
            
p.addOptional('brackets', defaultBrackets, ...
                @(q) any(validatestring(q, expectedBrackets)));
            
p.addOptional('decimation', defaultDecimation, @isnumeric);

p.addOptional('filename', defaultFilename);
            
parse(p, varargin{:})
environment = p.Results.environment;
align       = p.Results.align;
border      = p.Results.border;
brackets    = p.Results.brackets;
decimation  = p.Results.decimation;
filename    = p.Results.filename;

%% logic
if strcmp(environment, 'tabular') && ~(strcmp(brackets, 'br'))
    fprintf(['\nIf tabular enviroment is used, ' ...
             'brackets options is ignored\n']);
end

if strcmp(environment, 'matrix') && ~(strcmp(align, 'cc'))
    fprintf('\nIf matrix enviroment is used, align option is ignored\n');
end

if isempty(filename)
    error('filename is empty');
end

%% function source code
if strcmp(filename, '-')
    fid = 1;
    fprintf(fid, '\n');
else
    fid = fopen(filename, 'w');
end

% begin environment if tabular, then alignment of columns is neccesary if
% matrix used, then "bmatrix" environment is used as default
if strcmp(environment, 'tabular')
    fprintf(fid, ['\\begin{', environment, '}{']);
    if strcmp(border, 'yes')
        fprintf(fid, '|');
    end
    for k = 1:1:size(matrix, 2)
        if strcmp(align, 'cc')
            align = 'c';
        end
        fprintf(fid, align);
        if strcmp(border, 'yes')
            fprintf(fid, '|');
        end
    end
    fprintf(fid, '} \n');
else
    if strcmp(environment, 'matrix') && ...
       (strcmp(brackets, '[') || strcmp(brackets, ']') || ...
        strcmp(brackets, 'br'))
        environment = 'bmatrix';
    elseif strcmp(environment, 'matrix') && ...
       (strcmp(brackets, '(') || strcmp(brackets, ')'))
        environment = 'pmatrix';
    elseif strcmp(environment, 'matrix') && ...
       (strcmp(brackets, '{') || strcmp(brackets, '}'))
        environment = 'Bmatrix';
    elseif strcmp(environment, 'matrix') && strcmp(brackets, '|')
        environment = 'vmatrix';
    elseif strcmp(environment, 'matrix') && strcmp(brackets, '||')
        environment = 'Vmatrix';
    end
    fprintf(fid, ['\\begin{', environment, '}\n']);
end

[r, c] = size(matrix);
string = ['%8.' num2str(decimation) 'f'];
for i = 1:1:r
    for j = 1:1:c
        fprintf(fid, string, matrix(i, j));
        if j == c
            fprintf(fid, ' \\\\');
            if strcmp(border, 'yes') 
                fprintf(fid, ' \\hline');
            end
            fprintf(fid, ' \n');
        else
            fprintf(fid, ' &');
        end
    end
end

% end environment
fprintf(fid, ['\\end{', environment, '}']);
fprintf(fid, '\n');
if ~strcmp(filename, '-')
    fclose(fid);
end
end