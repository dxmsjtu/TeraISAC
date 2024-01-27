function X = zakTransform(x, fs)
    % x: 时域信号
    % fs: 采样频率

    N = length(x);          % 信号长度
    T_s = 1/fs;             % 采样周期
    X = zeros(N, N);        % 初始化 Zak 变换结果矩阵

    % 计算 Zak 变换
    for f = 1:N
        for tau = 1:N
            X(f, tau) = sum(x .* exp(-1j * 2 * pi * (f-1) * (0:N-1) * T_s) .* (tau-1 == round((0:N-1) * T_s)));
        end
    end
end