package org.zerock.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.PageMaker;
import org.zerock.domain.SearchCriteria;
import org.zerock.service.BoardService;

@Controller
@RequestMapping("/sboard/*")
public class SearchBoardController {

  private static final Logger logger = LoggerFactory.getLogger(SearchBoardController.class);

  @Autowired
  private BoardService boardService;

  @RequestMapping(value="/list", method=RequestMethod.GET)
  public void listPage(@ModelAttribute("cri") SearchCriteria cri, Model model) throws Exception {
	  logger.info(cri.toString());
	  
	  //model.addAttribute("list", boardService.listCriteria(cri));
	  
	  model.addAttribute("list", boardService.listSearchCriteria(cri));
	  
	  PageMaker pageMaker = new PageMaker();
	  pageMaker.setCri(cri);
	  
	  //pageMaker.setTotalCount(boardService.listSearchCount(cri));
	  pageMaker.setTotalCount(boardService.listSearchCount(cri));
	  
	  model.addAttribute("pageMaker", pageMaker);
  }
  
  @RequestMapping(value="/readPage", method=RequestMethod.GET)
  public void read(@RequestParam("bno") int bno, @ModelAttribute("cri") SearchCriteria cri, Model model) throws Exception {
	  model.addAttribute(boardService.read(bno));
  }
 
  @RequestMapping(value="/removePage", method=RequestMethod.POST)
  public String remove(@RequestParam("bno") int bno, SearchCriteria cri, RedirectAttributes rttr) throws Exception {
	  
	  boardService.remove(bno);
	  rttr.addAttribute("page", cri.getPage());
	  rttr.addAttribute("perPageNum", cri.getPerPageNum());
	  rttr.addAttribute("searchType", cri.getSearchType());
	  rttr.addAttribute("keyword", cri.getKeyword());
	  
	  rttr.addFlashAttribute("msg", "SUCCESS");
	  return "redirect:/sboard/list";
  }
  
  @RequestMapping(value="modifyPage", method=RequestMethod.GET)
  public void modifyPageGET(int bno, @ModelAttribute("cri") SearchCriteria cri, Model model) throws Exception {
	  model.addAttribute(boardService.read(bno));
  }
  
  @RequestMapping(value="modifyPage", method=RequestMethod.POST)
  public String modifyPagePOST(BoardVO board, SearchCriteria cri, RedirectAttributes rttr) throws Exception {
	  logger.info(cri.toString());
	  boardService.modify(board);
	  
	  rttr.addAttribute("page", cri.getPage());
	  rttr.addAttribute("perPageNum", cri.getPerPageNum());
	  rttr.addAttribute("searchType", cri.getSearchType());
	  rttr.addAttribute("keyword", cri.getKeyword());
	  
	  rttr.addFlashAttribute("msg", "SUCCESS");
	  logger.info(rttr.toString());
	  return "redirect:/sboard/list";
  }
  
  @RequestMapping(value="/register", method=RequestMethod.GET)
  public void registerGET() throws Exception {
	  logger.info("register");
  }
  
  @RequestMapping(value="/register", method=RequestMethod.POST)
  public String registerPOST(BoardVO board, RedirectAttributes rttr) throws Exception {
	  logger.info("register POST");  
	  logger.info(board.toString());
	  
	  boardService.regist(board);
	  rttr.addFlashAttribute("msg", "SUCCESS");
	  
	  return "redirect:/sboard/list";
  }
  
}
