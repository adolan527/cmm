% Define matrix size
rows = 4;
cols = 4;

% Generate random complex numbers
real_part = randi([-100,100], rows, cols) %randi([-32768, 32767], rows, cols); % 16-bit signed integers
imag_part = randi([-100,100], rows, cols) %randi([-32768, 32767], rows, cols);
matrix_a = complex(real_part, imag_part);

filename = 'matrix_a.txt'; % Create file name (e.g., row_001.txt)
fid = fopen(filename, 'w'); % Open file for writing

for i = 1:rows    
    for j = 1:cols
        real_hex = dec2hex(typecast(int16(real_part(i, j)), 'int16'), 4); % Convert real part to hex
        imag_hex = dec2hex(typecast(int16(imag_part(i, j)), 'int16'), 4); % Convert imag part to hex
        fprintf(fid, '%s%s\n', imag_hex, real_hex); % Write to file
    end
end

fclose(fid); % Close file

real_part = randi([-100,100], rows, cols) %randi([-32768, 32767], rows, cols); % 16-bit signed integers
imag_part = randi([-100,100], rows, cols) %randi([-32768, 32767], rows, cols);
matrix_b = complex(real_part, imag_part);

filename = 'matrix_b.txt' % Create file name (e.g., row_001.txt)
fid = fopen(filename, 'w'); % Open file for writing

for i = 1:rows    
    for j = 1:cols
        real_hex = dec2hex(typecast(int16(real_part(i, j)), 'int16'), 4); % Convert real part to hex
        imag_hex = dec2hex(typecast(int16(imag_part(i, j)), 'int16'), 4); % Convert imag part to hex
        fprintf(fid, '%s%s\n', imag_hex, real_hex); % Write to file
    end
end

fclose(fid); % Close file

result = matrix_a + matrix_b %generate sum

% Open file for writing
filename = 'matlab_result.txt';
fid = fopen(filename, 'w');
fid2 = fopen('matlab_readable_result.txt','w')

% Loop through matrix and write to file
for i = 1:rows
    for j = 1:cols
        real_hex = dec2hex(typecast(int32(real(result(i, j))), 'int32'), 10); % Convert real to hex
        imag_hex = dec2hex(typecast(int32(imag(result(i, j))), 'int32'), 10); % Convert imag to hex
        fprintf(fid, '%s%s ', imag_hex, real_hex); % Format: real|imag concatenated
    end
    fprintf(fid, '\n'); % New line at the end of each row
end

% Loop through matrix and write to file
for i = 1:4
    for j = 1:4
        fprintf(fid2, '%d + j%d\t ', real(result(i,j)), imag(result(i,j))); % Format: real|imag concatenated
    end
    fprintf(fid2, '\n'); % New line at the end of each row
end


% Close file
fclose(fid);
fclose(fid2);

