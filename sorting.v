module main

import rand
import rand.seed

import math
import term
/* import os */
import time

struct Column
{
	mut:
		value int
		/* selected bool */
}

const (
	b_size = 50
	r_iterations = 80
	sort_millis = 2
)

fn maprange(sourcenumber int,  froma int,  fromb int,  toa int,  tob int)int {
    deltaa := froma - froma
    deltab := tob - toa
    scale  := f32(deltab) / deltaa
    nega   := -1 * froma
    offset := (nega * scale) + toa
    finalnumber := (sourcenumber * scale) + offset
    return int(finalnumber)
}

fn render(selection int,cl []Column){
	assert selection >= -1 && selection < b_size
		//* index checking
	term.set_cursor_position(term.Coord{0,0})

	mut part := b_size
	for _ in 0..b_size {
		for i, c in cl{
			if c.value >= part{
				if i == selection{
					print(term.green("██"))
				}else{
					less := 1
					mut rgb := f64(c.value-1) / b_size * 255 * less
					mut rgbin := (((f64(c.value) / b_size) * -1.0) + 1.0) * 255 * less
					
					rgb += 10

					rgb = math.clamp(rgb, 0.0, 255.0)
					rgbin = math.clamp(rgbin, 0.0, 255.0)
					
						//* value is from 1 to b_size, turn it into 0 to 255
					print(term.rgb(int(rgb),int(rgb),int(rgb),"██"))
				}
			}else{
				print("  ")
			} //* side effect: remove else to make sorted list!
		}
		part--
		print("\n")
	}
	time.sleep(int(sort_millis*1000000.0))
}

fn wait(){
	time.sleep(1000*1000000)
}

fn main(){
	rand.seed(seed.time_seed_array(2))
	term.clear()

	term.hide_cursor()

	mut board := []Column{}
	for i in 0..b_size {
		board.insert(i,Column{value: i+1})
	} //! instantiate board

	render(-1,board)
	wait()
	time.sleep(1000*1000000)
	time.sleep(1000*1000000)

	for _ in 0..r_iterations{
		render(b_size-1,board)
		rpos := rand.int_in_range(0,b_size) or {panic("this")}
		board.insert(rpos,board.pop())
		render(rpos,board)
	} //! randomize board

	wait()

	for true {
		mut good := 0
		for i in 0..b_size-1{
			render(i,board)
			if board[i].value > board[i+1].value{
				render(i,board)
				swapi := board[i]
				board[i] = board[i+1]
				board[i+1] = swapi

				render(i+1,board)
			}else{
				good++
			}
		}
		if good == b_size-1{
			break
		}
	} //! bubble sort

	wait()

	for _ in 0..r_iterations{
		render(b_size-1,board)
		rpos := rand.int_in_range(0,b_size) or {panic("this")}
		board.insert(rpos,board.pop())
		render(rpos,board)
	} //! randomize board 

	wait()

	for i in 0..b_size{
		mut jmin := i
		for j in i+1..b_size {
			render(j,board)
			if board[j].value < board[jmin].value{
				jmin = j
				render(jmin,board)
			}
		}
		if jmin != i {
			render(jmin,board)
			swapi := board[i]
			board[i] = board[jmin]
			board[jmin] = swapi

			render(i,board)
		}else{
			render(jmin,board)
		}
	} //! selection sort

	wait()

	for _ in 0..r_iterations{
		render(b_size-1,board)
		rpos := rand.int_in_range(0,b_size) or {panic("this")}
		board.insert(rpos,board.pop())
		render(rpos,board)
	} //! randomize board 

	wait()

	for i in 1..b_size {
		x := board[i]
		mut j := i - 1

		render(i,board)
		for j >= 0 && board[j].value > x.value {
			board[j+1] = board[j]
			render(j+1,board)
			j--
		}
		board[j+1] = x
		render(j+1,board)
	} //! insertion sort


	term.show_cursor()
}