function [DominantGenes,Mask,MaskInverted]=Analyze(pop,Info)
%% Data Definition
Npop=size(pop,1);
n=size(pop(1).Position,2);
Ans=zeros(2,n);
Gens=[];
NFixedX=floor(Info.PFixedX*Npop);
pop=ConverC2D(pop,Info.NGap);
%% Find Dominant Gene
for i=1:n
    DominantGene=[];
    for j=1:Npop
        Gens=[Gens,pop(j).Position(1,i)];
    end
    while(size(Gens,2)~=0)
        temp=sum(Gens==Gens(1));
        if(size(DominantGene,2)==0)
            DominantGene=Gens(1);
            DominantGeneCounter=temp;
        else
            if(temp>DominantGeneCounter)
                DominantGene=Gens(1);
                DominantGeneCounter=temp;
            elseif(temp==DominantGeneCounter)
                DominantGene=[DominantGene,Gens(1)];
            end
        end
        Gens=Gens(Gens~=Gens(1));
    end
    if(size(DominantGene,2)==1)
        Ans(1,i)=DominantGene;
        Ans(2,i)=DominantGeneCounter;
    else
        Ans(1,i)=DominantGene(randsample(1:size(DominantGene,2),1));
        Ans(2,i)=DominantGeneCounter;
    end
end
%% Create Ans :
%Dominant
DominantGenes=Ans(1,:);
DominantGenes=DominantGenes./Info.NGap;
%Mask
Mask=zeros(1,n);
for i=1:n
    if(Ans(2,i)>=NFixedX && NFixedX~=0)
        Mask(i)=1;
    end
end
%MaskInverted
MaskInverted=ones(1,size(Mask,2));
TempMask=Mask*-1;
MaskInverted=abs(MaskInverted+TempMask);
end
