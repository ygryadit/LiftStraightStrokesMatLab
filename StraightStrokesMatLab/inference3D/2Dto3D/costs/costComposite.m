function cost_full = costComposite(pCoverage, ...
                                  pAllignVP, ...
                                  line_group,...
                                  DISP_INFO)
    
    
    global DIRECTIONAL_NON_AXIS;
    global USE_SIMPLE_COST;
    
    if ~DIRECTIONAL_NON_AXIS & line_group == 4
        w_coverage = 1.0;
        w_axis = 0.0;
    else
        w_coverage = 0.5;
        w_axis = 0.5;
    end
    
                          
    if ~USE_SIMPLE_COST
        pAllignVP = pAllignVP*w_axis;    
        pCoverage = pCoverage*w_coverage;

        weigth = w_coverage+w_axis+w_coverage*w_axis;

        cost_full = ( pCoverage+ ...
                      pAllignVP + ...
                      pAllignVP*pCoverage)/weigth;    %Ensures that the terms are balanced: e.g. 0.3 + 0.2 + 0.3*0.2 < 0.25 + 0.25 + 0.25*0.25
    else
        pAllignVP = pAllignVP*w_axis;    
        pCoverage = pCoverage*w_coverage;

        weigth = w_coverage+w_axis;

        cost_full = ( pCoverage + ...
                      pAllignVP)/weigth;  
    end
    
    if ~exist('DISP_INFO', 'var')
        DISP_INFO = false;
    end
        
    if DISP_INFO
        fprintf('coverage = %.2f,snap = %.2f,angle = %.2f\n',...
                pCoverage,...
                pIntersections,...
                pAllignVP);
        fprintf('pCoverage*pAllignVP = %.2f\n',...            
                pCoverage*pAllignVP);

        fprintf('full = %.2f\n', cost_full);
        disp('--------------');
    end
end


%           cost_full =  jointProbablity(...
%                             jointProbablity(...
%                                 jointProbablity(pAllignVP*pIntersections,...
%                                                 pCoverage*pIntersections),...
%                                 pCoverage*pAllignVP),...
%                             pAllignVP*pIntersections*pCoverage);


%         cost_full =  jointProbablity(...
%                             jointProbablity(...
%                                 pCoverage*pIntersections,...
%                                 pCoverage*pAllignVP),...

%         cost_full = jointProbablity(...
%                                 pCoverage*pIntersections,...
%                                 pCoverage*pAllignVP);

%         cost_full = jointProbablity(jointProbablity(pCoverage,pAllignVP),pIntersections); 
%         cost_full =  jointProbablity(...
%                             jointProbablity(...
%                                 jointProbablity(pAllignVP*pIntersections,...
%                                                 pCoverage*pIntersections),...
%                                 pCoverage*pAllignVP),...
%                             pAllignVP*pIntersections*pCoverage);