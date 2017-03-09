function varargout = projeto(varargin)


% PROJETO MATLAB code for projeto.fig
%      PROJETO, by itself, creates a new PROJETO or raises the existing
%      singleton*.
%
%      H = PROJETO returns the handle to a new PROJETO or the handle to
%      the existing singleton*.
%
%      PROJETO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJETO.M with the given input arguments.
%
%      PROJETO('Property','Value',...) creates a new PROJETO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projeto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projeto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projeto

% Last Modified by GUIDE v2.5 08-Mar-2017 21:51:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projeto_OpeningFcn, ...
                   'gui_OutputFcn',  @projeto_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before projeto is made visible.
function projeto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projeto (see VARARGIN)

% Choose default command line output for projeto
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projeto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projeto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in arquivo.
function arquivo_Callback(hObject, eventdata, handles)
% hObject    handle to arquivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Abrir Imagem e fazer uma copia
global im im2 
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end


im=imread(path);
im=im2double(im); 
im2=im; 
axes(handles.img_original);
imshow(im);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over texto_um.

function texto_um_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to texto_um (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in down_up.
function down_up_Callback(hObject, eventdata, handles)
global im_downup im2 
im_downup = im2;


contents = cellstr(get(hObject,'String'));
popChoice = contents{get(hObject,'Value')};

if (strcmp(popChoice,'Nenhum'))
    im_downup = im2;
elseif (strcmp(popChoice,'Downsampling Amostra'))
    im_downup = im2(1:4:end,1:4:end,:);
elseif (strcmp(popChoice,'Downsampling Media'))
    %media por interpolacao
    im_downup = imresize(im2,1/2,'bicubic');
    
elseif (strcmp(popChoice,'Upsampling Zero'))
    %pega o pixel do lado para completar
    im_downup = imresize(im2, 2, 'nearest');
    
elseif (strcmp(popChoice,'Upsampling Interpolacao'))
    %feito com interpolacao bicubica, pegando blocos 4x4 vizinhos para
    %comparacao
    im_downup = imresize(im2, 2, 'bicubic');
end


% --- Executes during object creation, after setting all properties.
function down_up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to down_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in convolucao.
function convolucao_Callback(hObject, eventdata, handles)
global im_downup im_convolucao 

 im_convolucao = im_downup; %Just Backup :)
 
contents = cellstr(get(hObject,'String'));
popChoice = contents{get(hObject,'Value')};

assignin('base','popChoice',popChoice);
if (strcmp(popChoice,'Nenhum'))
    im_convolucao = im_downup; %Caso mude de ideia no meio...
    % Convolucao com matriz identidade:
elseif (strcmp(popChoice,'Identity'))
    identidade = [0 0 0
                 0 1 0
                 0 0 0];
    im_convolucao = imfilter(im_downup, identidade, 'conv'); 
    
    %Convolucao com matriz de deteccao de borda
elseif (strcmp(popChoice,'Edge detection'))
    edge= [0 1 0
           1 -4 1
           0 1 0];
       im_convolucao = imfilter(im_downup, edge, 'conv');  
            
       %Convolucao com matriz para detalhes
elseif (strcmp(popChoice,'Sharpen'))
    sharpen = [ 0 -1 0
                -1 5 -1
                0 -1 0];
         im_convolucao = imfilter(im_downup, sharpen, 'conv');
         
         %Convolucao com blox blur
elseif (strcmp(popChoice,'Box blur'))
       b_blur = 1/9*[ 1 1 1
                     1 1 1
                     1 1 1];
         im_convolucao = imfilter(im_downup, b_blur, 'conv'); 
         
         %convolucao com gaussian blur
elseif (strcmp(popChoice,'Gaussian blur'))
        g_blur = 1/16 * [ 1 2 1
                          2 4 2
                          1 2 1];
         im_convolucao = imfilter(im_downup, g_blur, 'conv');  
         
         %convlucao com 5x5 unsharp
elseif (strcmp(popChoice,'Unsharp'))
        unsharp = -1/256*[ 1 4 6 4 1
                           4 16 24 16 4
                           6 24 -476 24 6
                           4 16 24 16 4
                           1 4 6 4 1];
        im_convolucao = imfilter(im_downup, unsharp, 'conv');
                       
end



% --- Executes during object creation, after setting all properties.
function convolucao_CreateFcn(hObject, eventdata, handles)
% hObject    handle to convolucao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in converter.
function converter_Callback(hObject, eventdata, handles)

contents = cellstr(get(hObject,'String'));
popChoice = contents{get(hObject,'Value')};
global im_convolucao im_converter im_marca

im_converter = im_convolucao;
% como ela vem convertida em double... 
im_converter = im_converter *255; 

x = size(im_converter,2);
y = size(im_converter,1);
transf_conv = fft2(im_converter/255);

if (strcmp(popChoice,'Nenhum'))
    im_converter = im_convolucao; %caso queira voltar atras...
elseif (strcmp(popChoice,'Passa-baixa'))
    %calculo das frequencias
    %frequencia de corte e ordem do filtro fixadas... Arrumar isso se der
    %tempo
    temp_baixa = baixas(50,3,y,x);
    %Apos testes, esse e o jeito mais rapido de multiplicar duas matrizes,
    %no caso:
    I = 1;
     while (I <= y),J = 1;

       while (J <= x),
           trfconvbaixa(I,J)   = transf_conv(I,J) * temp_baixa(I,J);
           J = J + 1;
       end
     I = I + 1;
     end
    im_converter = abs(ifft2(trfconvbaixa));
    
elseif (strcmp(popChoice,'Passa-alta'))
    temp_alta = altas(50,3,y,x);
    I = 1;
     while (I <= x),J = 1;

       while (J <= y),
           trfconvalta(I,J)   = transf_conv(I,J) * temp_alta(I,J);
           J = J + 1;
       end
     I = I + 1;
     end
    im_converter = abs(ifft2(trfconvalta));
    
elseif (strcmp(popChoice,'Watermark'))
 
 if size(im_converter,3) == 1
     im_converter = rgb2gray (im_converter);
 end

[path,user_cance]=imgetfile();
    if user_cance
        msgbox(sprintf('Error'),'Error','Error');
        return
    end
    marca = imread(path);
    temp_fft = fft2(im_converter);
    temp_shift = fftshift(temp_fft);
   
  
    %lendo logo e transformando ele em cinza
    if size(marca,3) == 1
        marca = rgb2gray(marca);
    end
    %escala de cinza para imagem
    marca = im2bw(marca,0.7);

    y_logo = size(marca ,1);       
    x_logo = size(marca, 2);
    
    %logo central
    temp_shift(x / 2:(x / 2+ x_logo - 1), ...
     y / 2 :(y / 2 + y_logo - 1)) = marca;
    im_marca = temp_shift;
    
    marca_final = ifftshift(temp_shift);
    marca_final = ifft2(marca_final);
    im_converter = uint8(marca_final);
 
    
end



function converter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to converter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in editar.
function editar_Callback(hObject, eventdata, handles)
% hObject    handle to editar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Abrir imagem editada
global im_converter

axes(handles.img_editada);
imshow(im_converter);



% --- Executes on button press in salvar.
function salvar_Callback(hObject, eventdata, handles)
% hObject    handle to salvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_converter

[im_converter, user_cance]=imsave();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end


% --- Executes on button press in marca.
function marca_Callback(hObject, eventdata, handles)
% hObject    handle to marca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_marca

axes(handles.img_editada);
imshow(im_marca);
clear im_marca;



function corte_Callback(hObject, eventdata, handles)
% hObject    handle to corte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of corte as text
%        str2double(get(hObject,'String')) returns contents of corte as a double


% --- Executes during object creation, after setting all properties.
function corte_CreateFcn(hObject, eventdata, handles)
% hObject    handle to corte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ordem_Callback(hObject, eventdata, handles)
% hObject    handle to ordem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordem as text
%        str2double(get(hObject,'String')) returns contents of ordem as a double


% --- Executes during object creation, after setting all properties.
function ordem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
