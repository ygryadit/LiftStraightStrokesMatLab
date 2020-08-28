function [strokes_topology,...
            intersections,...
            expectedNumberCandidateLines] = ...
                    assignOnePrevStrokeCheckCandidateLinesSimplified(cur_stroke_ind,...
                        strokes_topology,...
                        intersections,...
                        pairsInterInter,...
                        cam_param,...
                        inds_non_assigned_strks)
                    
    %% Assign the stroke:
    ind_strk = inds_non_assigned_strks(1);

    strk_assign = strokes_topology(ind_strk);
    strk_assign.ind = ind_strk;

    UP_TO_LAST = true;
    [strk_assign.inds_intrsctns_eval,...
     strk_assign.inds_intrsctns_eval_actv,...
     strk_assign.inds_intrsctns_eval_mltpl_cnddts,...
     strk_assign.inds_intrsctng_strks_eval,...
     strk_assign.inds_intrsctng_strks_eval_actv,...
     strk_assign.inds_intrsctng_strks_eval_mltpl_cnddts] = ...
        returnIndicesNodesTypes(strk_assign, ...
                            cat(1, strokes_topology(:).depth_assigned),...
                                        intersections,...
                                        UP_TO_LAST);
                                    

    try
    [strokes_topology, intersections] = ...
        checkDepthAssignemnt(strokes_topology, ...
                             intersections,...
                             strk_assign,...
                             strk_assign.candidate_lines,...
                             pairsInterInter,...
                             cam_param,...
                             true);
    catch e
        rethrow(e);
    end



    %% Directional prior:
    
    cur_stroke = strokes_topology(cur_stroke_ind);
    cur_stroke.ind = cur_stroke_ind;
    
      
    UP_TO_LAST = true;
    [cur_stroke.inds_intrsctns_eval,...
     cur_stroke.inds_intrsctns_eval_actv,...
     cur_stroke.inds_intrsctns_eval_mltpl_cnddts,...
     cur_stroke.inds_intrsctng_strks_eval,...
     cur_stroke.inds_intrsctng_strks_eval_actv,...
     cur_stroke.inds_intrsctng_strks_eval_mltpl_cnddts] = ...
        returnIndicesNodesTypes(cur_stroke, ...
                            cat(1, strokes_topology(:).depth_assigned),...
                                        intersections,...
                                        UP_TO_LAST);
                                    
    
    if ismember(cur_stroke.line_group, [1,2,3])
        % Direction towards vanishing lines:    
        direction_prior = getDirectionVec(cur_stroke.line_group);
    else
        direction_prior = [];
    end
   
    %% Find expected number of candidate lines:            
    expectedNumberCandidateLines = computeExpectedNumberCandidateLines(cur_stroke, strokes_topology, intersections);
end
     