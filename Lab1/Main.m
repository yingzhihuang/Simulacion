 
clc
close all
clear all

eta=0.1; %%% Taza de aprendizaje
grado=5; %%% Grado del polinomio

Tipo = 2;

if Tipo==1
    
    %%% Se crean los datos de forma aleatoria %%%
    
    X1=linspace(-20,20,500); %% genera 500 datos espaciados en (x2-x1)/(n-1) entre -20 y 20
    X2=linspace(-50,50,500); %% genera 500 datos espaciados en (x2-x1)/(n-1) entre -50 y 50
    X=[X1',X2']; %%X contiene la transpuesta de X1 y X2
    
    %%%%%%%%%%%%%% generar dato de salida%%%%%%%%%%%%%%%%%%%%%%%%%%
    X=zscore(X); 
    Y=2*X.^3 + 4*X.^2 - 8*X + 5;
    Y=min(abs(Y),[],2) + max(abs(Y),[],2).*0.2.*randn(500,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    X=[X1',X2'];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Se cambia el grado del polinomio %%%
    
    X=potenciaPolinomio(X,grado);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

    %%% Se hace la particion entre los conjuntos de entrenamiento y prueba.
    %%% Esta particion se hace forma aletoria %%%
    
    rng('default');
    ind=randperm(500); %%% Se seleccionan los indices de forma aleatoria
                            %%retorna un verctor que contiene una
                            %%permutacion aleatoria de enteros desde uno
                            %%hasta 500
    
    Xtrain=X(ind(1:450),:);
    Xtest=X(ind(451:end),:);
    Ytrain=Y(ind(1:450),:);
    Ytest=Y(ind(451:end),:);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Normalizacion %%%
    
    [Xtrain,mu,sigma]=zscore(Xtrain);
    Xtest=normalizar(Xtest,mu,sigma);
    
    %%%%%%%%%%%%%%%%%%%%%
    
    %%% Se extienden las matrices %%%
    
    Xtrain=[Xtrain,ones(450,1)];
    Xtest=[Xtest,ones(50,1)];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Se aplica la regresion multiple %%%
    
    W=regresionMultiple(Xtrain,Ytrain,eta,Xtest,Ytest); %%% Se obtienen los W coeficientes del polinomio
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Se encuentra el error cuadratico medio %%%
    
    Yesti=(W'*Xtest')';
    ECM=(sum((Yesti-Ytest).^2))/length(Ytest);
    
%   Texto=strcat('El Error cuadr�tico medio en prueba es: ',{' '},num2str(ECM));
    Texto=['El Error cuadratico medio en prueba es: ',num2str(ECM)];
    disp(Texto);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif Tipo==2
    
    %%% Se crean los datos de forma aleatoria %%%
    
    rng('default');
    
    a=(2*pi).*rand(250,1); %% se crean valores entre 0 y 2*pi
    r=sqrt(rand(250,1))+2; %% se crean valores aleatorios entre 2 y 3
    carac1=(3*r).*cos(a)-1; %% se generan valores entre -10 y 8
    carac2=(3*r).*sin(a)+3; %% se generan valores entre -6 y 12
    X1=[carac1,carac2]; %% se agregan las caracteristicas en X1

    a=(2*pi).*rand(250,1);%% se crean valores entre 0 y 2*pi
    r=sqrt(rand(250,1)); %% se crean valores aleatorios entre 0 y 1
    carac1=(2*r).*cos(a)-1; %% se generan valores entre -3 y 1
    carac2=(2*r).*sin(a)+3; %% se generan valores entre 3 y 5
    X2=[carac1,carac2]; %% se agregan las caracteristicas en X2
   
%     figure(2)
%     plot(X1(:,1),X1(:,2),'o',X2(:,1),X2(:,2),'*')
    
    X=[X1;X2]; %% se crea una matriz con los datos de entrada
    Y=[ones(250,1);zeros(250,1)]; %% los datos de salida tendran una columna de unos y una columna de ceros

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Se cambia el grado del polinomio %%%
    
    X=potenciaPolinomio(X,grado);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    %%% Se hace la partici�n entre los conjuntos de entrenamiento y prueba.
    %%% Esta partici�n se hace forma aletoria %%%
    
    rng('default');
    ind=randperm(500); %%% Se seleccionan los indices de forma aleatoria
    
    Xtrain=X(ind(1:450),:);
    Xtest=X(ind(451:end),:);
    Ytrain=Y(ind(1:450),:);
    Ytest=Y(ind(451:end),:);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Normalizacion %%%
    
    [Xtrain,mu,sigma]=zscore(Xtrain); %% se normalizan los datos de entrada para el entrenamiento
    Xtest=normalizar(Xtest,mu,sigma); %% se normalizan lo detos de entrada para prueba
    
    %%%%%%%%%%%%%%%%%%%%%
    
    %%% Se extienden las matrices %%%
    
    Xtrain=[Xtrain,ones(450,1)]; %% se agrega el vector de unos para los datos de entrada de entrenamiento
    Xtest=[Xtest,ones(50,1)];%% se agrega el vector de unos para los datos de entrada de prueba
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Se aplica la regresi�n logistica %%%
   
    W=regresionLogistica(Xtrain,Ytrain,eta); %%% Se optienen los W coeficientes del polinomio
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Se encuentra la eficiencia y el error de clasificaci�n %%%
   
    Yesti=(W'*Xtest')';
    Yesti(Yesti>=0)=1;
    Yesti(Yesti<0)=0;
    
    Eficiencia=(sum(Yesti==Ytest))/length(Ytest);
    Error=1-Eficiencia;
    
%     Texto=strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia));
    Texto=['La eficiencia en prueba es: ',num2str(Eficiencia)];
    disp(Texto);
%     Texto=strcat('El error de clasificaci�n en prueba es: ',{' '},num2str(Error));
    Texto=['El error de clasificaci�n en prueba es: ',num2str(Error)];
    disp(Texto);
    
    %%%%%%%%%%%%%%%%%%%funcion discriminante gaussiana%%%%%%%%%%%%%%%%%%%%%
    
    Xfdptrain=Xtrain(:,1:2);
    Xfdptest=Xtest(:,1:2);
    Yfdptrain=Ytrain;
    Yfdptest=Ytest;
    
    class = classify(Xfdptest,Xfdptrain,Yfdptrain,'quadratic');
    
    Eficiencia=(sum(class==Yfdptest))/length(Yfdptest);
    Error=1-Eficiencia;
    
    Texto=['La eficiencia usando una fdp en prueba es:',num2str(Eficiencia)];
    disp(Texto);
    Texto=['El error usando una fdp en prueba es:',num2str(Error)];
    disp(Texto);

end
