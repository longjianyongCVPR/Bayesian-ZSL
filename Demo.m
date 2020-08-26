% Sarkhan Badirli
% Bayesian Zero Shot Learning
%%%%%%%%%%%%%%%%   DEMO    %%%%%%%%%%%%%%%%%%%%
% This fuction demostrates the usage of BZSL on the datasets in (Generalized)
% Zero-shot learning domain: CUB, aPY, SUN, AWA & FLO
% The flow of the Demo is as follows,
% 1.    Load the one of the abovementioned data, they have specific train and
% test split nad attached attributes for each class. We have utilized the
% train, test and validation split provided in the datasets itself.
%
% 2.    Partitioning the training data into training and test data for the
% purpose of hyperparamter tuning. tuning_split.m script splits the training
% data into training and test (2 seperate sets: seen and unseen classes).  
% All these datasets have their ZSL specified partitioning and we followed  
% the exact same splitting fashion as in the literature.
%
% 3.    Hyperparameter tuning for the parameters of the BZSL. The matlab
% scritp hyperparameter_tuning.m implements this tuning. The must inputs
% for the tuning is the data split from tuning_split, attriburtes and Model
% version of the BZSL, constrained or unconstrained. If the unconstrained
% model is chosen you can specify the # principal components in the PCA which 
% used as dimensionality reduction technique in unconstrained model. EX: 
%   hyperparameter_tuning(Data split...,'Model', 'unconstrained', 'pca', 500);
% The script returns the desired hyperparameters  required for each model.
% For more details about hyperparameters please refer to the paper.
%
% 4. After getting the parameters, we used the train and test split
% provided within  datasets. We made use of Generalized ZSL setting for the
% split.
%
% 5. Lastly the BZSL model is run. The must inputs for the BZSL is data
% split from step 4, attributes, and the hyperparameters from tuning. Most
% of the hyper-parameters are the same for both models yet there are some
% differences. Please refer to the paper for the full list of
% hyperparameters of each model version. Since random number generation
% involved in the constrained model you could define number of iterations
% in this model to alleviate the randomness on the H score MOreover, there 
% is a tuning option for the BZSL where it is faster in this option if tuning 
% is being performed; ['tuning', true]  Ex: (constrained)
%     Bayesian_ZSL(Data split...,'Model', 'constrained', 'prior_mean', mu_0,...
%     'kappa_0', k_0, 'kappa_1', k_1, 'cov_shape', m, 'invg_shape', a_0, 'invg_scale', b_0, 'iter', 5);
%
% Ex: (unconstrained)
%     Bayesian_ZSL(Data split...,'Model','unconstrained', 'tuning', true, 'prior_mean', mu_0, 
%     'prior_cov', psi, 'kappa_0', k_0, 'kappa_1', k_1, 'cov_shape', m, 'pca', 500);

clear all;
%clc;



fname1='C:\Users\sbadirli\Dropbox\My PC (DESKTOP-5LTVPHA)\Desktop\Bayesian ZSL\data\AWA1\res101.mat';   
fname2='C:\Users\sbadirli\Dropbox\My PC (DESKTOP-5LTVPHA)\Desktop\Bayesian ZSL\data\AWA1\att_splits.mat';
load(fname1)
load(fname2)
% Splitting the training data into training and test data for the use in
% hyper-parameter tuning
%[xtrain, ytrain, xtest_unseen, ytest_unseen, xtest_seen, ytest_seen] = tuning_split(features, train_loc, val_loc, labels, fname2);

% Tuning process
%[k_0, k_1, m, a_0, b_0, mu_0, s, K] = hyperparameter_tuning(xtrain,ytrain,xtest_unseen,ytest_unseen,xtest_seen,ytest_seen,att,'Model', 'unconstrained', 'pca', 500);
k_0=10; k_1=10; a_0=10; b_0 = 1; m=500*500; s=3; K=2;
% Splitting the data into train and test
% tr -- train, ts -- test, s -- seen, us -- unseen, x -- data matrix, 
% y -- labels 

%Temporary h-params
%k_0 = 0.1; k_1 = 0.1; m=10*500; s=3; K=1;

[x_tr, y_tr, x_ts_us, y_ts_us, x_ts_s, y_ts_s] = split_data(features, trainval_loc, test_unseen_loc, test_seen_loc, labels);
%[x_tr, y_tr, ~, ~, ~, ~] = split_data(features, trainval_loc, test_unseen_loc, test_seen_loc, labels);

% train and test the data in GZSL setting
% [gzsl_seen_acc, gzsl_unseen_acc, H] = Bayesian_ZSL(x_tr, y_tr, x_ts_us, y_ts_us, x_ts_s, y_ts_s, att,'Model', 'constrained','num_neighbor', K,...
%                                                    'kappa_0', k_0, 'kappa_1', k_1, 'invg_shape', a_0, 'invg_scale', b_0);
[gzsl_seen_acc, gzsl_unseen_acc, H] = Bayesian_ZSL(x_tr, y_tr, x_ts_us, y_ts_us, x_ts_s, y_ts_s, att,'Model', 'unconstrained','num_neighbor', K,...
                                                   'kappa_0', k_0, 'kappa_1', k_1,'cov_shape', m,'prior_covscale',s, 'pca', 500);
                                               
                                               