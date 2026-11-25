clear;clc

numObs = 25;
obsInfo = rlNumericSpec([25 1], ...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf]', ...
    'UpperLimit',[inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf inf]') % body_acc, f_spring, sus_disp, f_damp, road)
% actInfo = rlFiniteSetSpec([-500 0 500])
actInfo = rlNumericSpec([1 1],'LowerLimit',-4000,'UpperLimit',4000) 
obsInfo.Name = 'Observations';
actInfo.Name = 'Control force';
env = rlSimulinkEnv('quartercar_RL_6_no_G','quartercar_RL_6_no_G/RL Agent',obsInfo,actInfo)
set_param('quartercar_RL_6_no_G', 'AlgebraicLoopSolver','Auto');



Ts = 0.05;
Tf = 10;

rng(0)

statePath = [
    featureInputLayer(numObs,'Normalization','none','Name','observation')
    fullyConnectedLayer(100,'Name','CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(100,'Name','CriticStateFC2')];
actionPath = [
    featureInputLayer(1,'Normalization','none','Name','action')
    fullyConnectedLayer(100,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
commonPath = [
    additionLayer(2,'Name','add')
    sigmoidLayer
    fullyConnectedLayer(50)
    sigmoidLayer
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
    
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');
criticNetwork = dlnetwork(criticNetwork);
figure
plot(layerGraph(criticNetwork))
plot(layerGraph(actorNetwork))
criticOpts = rlOptimizerOptions('LearnRate',1e-03,'GradientThreshold',1);

critic = rlQValueFunction(criticNetwork,obsInfo,actInfo,'ObservationInputNames','observation','ActionInputNames','action',UseDevice="gpu");

actorNetwork = [
    featureInputLayer(numObs,'Normalization','none','Name','observation')
    fullyConnectedLayer(100,'Name','ActorFC1')
    tanhLayer
    fullyConnectedLayer(100,'Name','ActorFC2')
    tanhLayer
    fullyConnectedLayer(50,'Name','ActorFC3')
    tanhLayer('Name','ActorTanh')
    fullyConnectedLayer(1,'Name','ActorFC4')
    tanhLayer('Name','ActorTanh2')
    scalingLayer('Name','ActorScaling','Scale',max(actInfo.UpperLimit))];
actorNetwork = dlnetwork(actorNetwork);

actorOpts = rlOptimizerOptions('LearnRate',1e-04,'GradientThreshold',1);

actor = rlContinuousDeterministicActor(actorNetwork,obsInfo,actInfo,UseDevice="gpu");

agentOpts = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'CriticOptimizerOptions',criticOpts,...
    'ActorOptimizerOptions',actorOpts,...
    'ExperienceBufferLength',1e6,...
    'ResetExperienceBufferBeforeTraining',true,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',64);
agentOpts.NoiseOptions.Variance = 0.6;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;

agent = rlDDPGAgent(actor,critic,agentOpts);

maxepisodes = 5000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',5,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-5,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',-100);

doTraining = true;
if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    % Load the pretrained agent for the example.
    % load('SimulinkPendulumDDPG.mat','agent')
end