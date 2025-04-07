%{ 

Original expression: (multiply_sum)
(sh * r * s) / (sh * s)

Verilog implementation: (hadamard_sum)
sum(r .* (s * sh) / (sh * s))
or 
r dot ((s * sh) / (sh * s))

Everything except for r can be precomputed, therefore the actual
implementation is:
sum(r .* Constant)

multiply_sum operations:
sh * r: 16 multiplys, 12 add
shr * s: 4 multiply, 3 add
shrs / shs: 1 divide, 
Total: 20 multiply, 1 divide, 15 add

hadamard_sum operations:
r .* constant: 16 multiplys, 15 add
Total: 16 multiplys, 0 divide, 15 add

%}

S_LOWER_BOUND = -250;
S_UPPER_BOUND = 250;
R_LOWER_BOUND = -250;
R_UPPER_BOUND  = 250;

fid = fopen('bartlett.csv', 'w'); % Open file for writing
fprintf(fid,"s1,s2,s3,s4,sh*s,multiply,hadamard,r\n");


for l = 1:10
    % Define S matrix size
    rows = 4;
    cols = 1;
    
    % Generate random complex numbers
    real_part = randi([S_LOWER_BOUND,S_UPPER_BOUND], rows, cols); 
    imag_part = randi([S_LOWER_BOUND,S_UPPER_BOUND], rows, cols);
    s = complex(real_part, imag_part);
    sh = s'; 
    denom = sh * s;

for k = 1:10 
    % Define R matrix size
    rows = 4;
    cols = 4;
    
    % Generate random complex numbers
    real_part = randi([R_LOWER_BOUND,R_UPPER_BOUND], rows, cols); 
    imag_part = randi([R_LOWER_BOUND,R_UPPER_BOUND], rows, cols);
    r = complex(real_part, imag_part);
    
    % multiply_sum
    multiply_sum = (sh * r * s)/denom;
    
    %hadamard_sum
    special = zeros(4,4);
    for i = 1:rows  % Loop over rows
        for j = 1:rows % Loop over columns
            special(i,j) = sh(i) * s(j);
        end
    end
    
    special = special/denom;
    hadamard_sum = sum(special .* r,"all");
    

    % Print
    
    display(multiply_sum)
    
    display(hadamard_sum)



    
    for i = 1:rows
        fprintf(fid,"%f + j%f,",real(s(i)),imag(s(i)));
    end

    fprintf(fid,"%f + j%f, %f + j%f, %f + j%f,",real(denom),imag(denom),real(multiply_sum),imag(multiply_sum),real(hadamard_sum),imag(hadamard_sum));

    
    for i = 1:16
        fprintf(fid,"%f + j%f,",real(r(i)),imag(r(i)));
    end
    fprintf(fid,"\n");
    
end    
end
fclose(fid); % Close file
