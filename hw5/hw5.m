clc; close; clear all
%%
load('fashion_mnist.mat');

% image to double
X_test = im2double(X_test);
X_train = im2double(X_train);

y_test = im2double(y_test);
y_train = im2double(y_train);

% reshape and reorder
X_train = reshape(X_train,[60000 28 28 1]);
X_train = permute(X_train,[2 3 4 1]);

X_test = reshape(X_test,[10000 28 28 1]);
X_test = permute(X_test,[2 3 4 1]);

% better to randomalize
X_valid = X_train(:,:,:,1:5000);
X_train = X_train(:,:,:,5001:end);




y_valid = categorical(y_train(1:5000))';
y_train = categorical(y_train(5001:end))';
y_test = categorical(y_test)';


layers = [imageInputLayer([28 28 1])
        fullyConnectedLayer(200)
        reluLayer
        fullyConnectedLayer(50)
        reluLayer
        fullyConnectedLayer(100) %
        reluLayer %
        fullyConnectedLayer(10)
        softmaxLayer
        classificationLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',5,...
    'InitialLearnRate',2e-3, ...
    'L2Regularization',7e-4, ...
    'ValidationData',{X_valid,y_valid}, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(X_train,y_train,layers,options);
%% Confusion for training
figure(2)
y_pred = classify(net,X_train);
plotconfusion(y_train,y_pred)

%% Test classifier
figure(3)
y_pred = classify(net,X_test);
plotconfusion(y_test,y_pred)